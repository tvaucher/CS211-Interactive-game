import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.ArrayList;

class QuadGraph {
  List<int[]> cycles = new ArrayList<int[]>();
  int[][] graph;

  QuadGraph(List<PVector> lines, int width, int height) {

    int n = lines.size();

    // The maximum possible number of edges is n * (n - 1)/2
    graph = new int[n * (n - 1)/2][2];

    int idx = 0;

    for (int i = 0; i < lines.size(); i++) {
      for (int j = i + 1; j < lines.size(); j++) {
        if (intersect(lines.get(i), lines.get(j), width, height)) {
          graph[idx][0] = i;
          graph[idx][1] = j;
          idx++;
        }
      }
    }
  }

  PVector intersection(PVector line1, PVector line2) {
    double sin_t1 = Math.sin(line1.y);
    double sin_t2 = Math.sin(line2.y);
    double cos_t1 = Math.cos(line1.y);
    double cos_t2 = Math.cos(line2.y);
    float r1 = line1.x;
    float r2 = line2.x;

    double denom = cos_t2 * sin_t1 - cos_t1 * sin_t2;
    int x = (int) ((r2 * sin_t1 - r1 * sin_t2) / denom);
    int y = (int) ((-r2 * cos_t1 + r1 * cos_t2) / denom);

    return new PVector(x, y);
  }
  /** Returns true if polar lines 1 and 2 intersect 
   * inside an area of size (width, height)
   */
  boolean intersect(PVector line1, PVector line2, int width, int height) {
    PVector inter = intersection(line1, line2);
    return (0 <= inter.x && 0 <= inter.y && width >= inter.x && height >= inter.y);
  }

  List<int[]> findCycles() {

    cycles.clear();
    for (int i = 0; i < graph.length; i++) {
      for (int j = 0; j < graph[i].length; j++) {
        findNewCycles(new int[] {graph[i][j]});
      }
    }
    for (int[] cy : cycles) {
      String s = "" + cy[0];
      for (int i = 1; i < cy.length; i++) {
        s += "," + cy[i];
      }
      //System.out.println(s);
    }
    return cycles;
  }

  void findNewCycles(int[] path) {
    int n = path[0];
    int x;
    int[] sub = new int[path.length + 1];

    for (int i = 0; i < graph.length; i++)
      for (int y = 0; y <= 1; y++)
        if (graph[i][y] == n)
          //  edge refers to our current node
        {
          x = graph[i][(y + 1) % 2];
          if (!visited(x, path))
            //  neighbor node not on path yet
          {
            sub[0] = x;
            System.arraycopy(path, 0, sub, 1, path.length);
            //  explore extended path
            findNewCycles(sub);
          } else if ((path.length == 4) && (x == path[path.length - 1]))
            //  cycle found
          {
            int[] p = normalize(path);
            int[] inv = invert(p);
            if (isNew(p) && isNew(inv)) {
              cycles.add(p);
            }
          }
        }
  }

  //  check of both arrays have same lengths and contents
  Boolean equals(int[] a, int[] b) {
    Boolean ret = (a[0] == b[0]) && (a.length == b.length);

    for (int i = 1; ret && (i < a.length); i++) {
      if (a[i] != b[i]) {
        ret = false;
      }
    }

    return ret;
  }

  //  create a path array with reversed order
  int[] invert(int[] path)
  {
    int[] p = new int[path.length];

    for (int i = 0; i < path.length; i++)
    {
      p[i] = path[path.length - 1 - i];
    }

    return normalize(p);
  }

  //  rotate cycle path such that it begins with the smallest node
  int[] normalize(int[] path)
  {
    int[] p = new int[path.length];
    int x = smallest(path);
    int n;

    System.arraycopy(path, 0, p, 0, path.length);

    while (p[0] != x)
    {
      n = p[0];
      System.arraycopy(p, 1, p, 0, p.length - 1);
      p[p.length - 1] = n;
    }

    return p;
  }

  //  compare path against known cycles
  //  return true, iff path is not a known cycle
  Boolean isNew(int[] path)
  {
    Boolean ret = true;

    for (int[] p : cycles)
    {
      if (equals(p, path))
      {
        ret = false;
        break;
      }
    }

    return ret;
  }

  //  return the int of the array which is the smallest
  int smallest(int[] path)
  {
    int min = path[0];

    for (int p : path)
    {
      if (p < min)
      {
        min = p;
      }
    }

    return min;
  }

  //  check if vertex n is contained in path
  Boolean visited(int n, int[] path)
  {
    Boolean ret = false;

    for (int p : path)
    {
      if (p == n)
      {
        ret = true;
        break;
      }
    }

    return ret;
  }



  /** Check if a quad is convex or not.
   * 
   * Algo: take two adjacent edges and compute their cross-product. 
   * The sign of the z-component of all the cross-products is the 
   * same for a convex polygon.
   * 
   * See http://debian.fmi.uni-sofia.bg/~sergei/cgsr/docs/clockwise.htm
   * for justification.
   * 
   * @param c1
   */
  boolean isConvex(PVector c1, PVector c2, PVector c3, PVector c4) {

    PVector v21= PVector.sub(c1, c2);
    PVector v32= PVector.sub(c2, c3);
    PVector v43= PVector.sub(c3, c4);
    PVector v14= PVector.sub(c4, c1);

    float i1=v21.cross(v32).z;
    float i2=v32.cross(v43).z;
    float i3=v43.cross(v14).z;
    float i4=v14.cross(v21).z;

    if (   (i1>0 && i2>0 && i3>0 && i4>0) 
      || (i1<0 && i2<0 && i3<0 && i4<0))
      return true;
    else 
    System.out.println("Eliminating non-convex quad");
    return false;
  }

  /** Compute the area of a quad, and check it lays within a specific range
   */
  boolean validArea(float area, float min_area, float max_area) {

    boolean valid = (area < max_area && area > min_area);

    if (!valid) System.out.println("Area out of range");

    return valid;
  }

  float area(PVector c1, PVector c2, PVector c3, PVector c4) {
    PVector v21= PVector.sub(c1, c2);
    PVector v32= PVector.sub(c2, c3);
    PVector v43= PVector.sub(c3, c4);
    PVector v14= PVector.sub(c4, c1);

    float i1=v21.cross(v32).z;
    float i2=v32.cross(v43).z;
    float i3=v43.cross(v14).z;
    float i4=v14.cross(v21).z;

    float area = Math.abs(0.5f * (i1 + i2 + i3 + i4));
    //System.out.println(area);
    return area;
  }
  /** Compute the (cosine) of the four angles of the quad, and check they are all large enough
   * (the quad representing our board should be close to a rectangle)
   */
  boolean nonFlatQuad(PVector c1, PVector c2, PVector c3, PVector c4) {

    // cos(70deg) ~= 0.3
    float min_cos = 0.5f;

    PVector v21= PVector.sub(c1, c2);
    PVector v32= PVector.sub(c2, c3);
    PVector v43= PVector.sub(c3, c4);
    PVector v14= PVector.sub(c4, c1);

    float cos1=Math.abs(v21.dot(v32) / (v21.mag() * v32.mag()));
    float cos2=Math.abs(v32.dot(v43) / (v32.mag() * v43.mag()));
    float cos3=Math.abs(v43.dot(v14) / (v43.mag() * v14.mag()));
    float cos4=Math.abs(v14.dot(v21) / (v14.mag() * v21.mag()));

    if (cos1 < min_cos && cos2 < min_cos && cos3 < min_cos && cos4 < min_cos)
      return true;
    else {
      System.out.println("Flat quad");
      return false;
    }
  }


  List<PVector> sortCorners(List<PVector> quad) {

    // 1 - Sort corners so that they are ordered clockwise
    PVector a = quad.get(0);
    PVector b = quad.get(2);

    PVector center = new PVector((a.x+b.x)/2, (a.y+b.y)/2);

    Collections.sort(quad, new CWComparator(center));

    // 2 - Sort by upper left most corner
    PVector origin = new PVector(0, 0);
    float distToOrigin = 1000;

    for (PVector p : quad) {
      if (p.dist(origin) < distToOrigin) distToOrigin = p.dist(origin);
    }

    while (quad.get(0).dist(origin) != distToOrigin)
      Collections.rotate(quad, 1);


    return quad;
  }


  int[] getBestQuad(List<PVector> lines) {
    int[] bestQuad = null;
    float maxArea = 0;
    for (int[] quad : cycles) {

      PVector l1 = lines.get(quad[0]);
      PVector l2 = lines.get(quad[1]);
      PVector l3 = lines.get(quad[2]);
      PVector l4 = lines.get(quad[3]);

      List<PVector> c = new ArrayList<PVector>(4);
      c.add(intersection(l1, l2));
      c.add(intersection(l2, l3));
      c.add(intersection(l3, l4));
      c.add(intersection(l4, l1));
      sortCorners(c);

      PVector c1 = c.get(0), c2 = c.get(1), c3 = c.get(2), c4 = c.get(3);

      boolean convex = isConvex(c1, c2, c3, c4);
      float area = area(c1, c2, c3, c4);
      boolean valid = validArea(area, MIN_AREA, MAX_AREA);
      boolean flat = nonFlatQuad(c1, c2, c3, c4);
      if (convex && valid && flat && area > maxArea) {
        maxArea = area;
        bestQuad = quad;
      }
    }
    
    return bestQuad;
  }


  void displayBestQuad(List<PVector> lines, int w) {
    int[] quad = getBestQuad(lines);
    if (quad == null) return; //Don't want to draw best quad if there isn't any => try to fit thresholding
    ArrayList<PVector> l = new ArrayList<PVector>(4);
    for (int i = 0; i < 4; ++i) {
      l.add(lines.get(quad[i]));
    }

    PVector l1 = l.get(0);
    PVector l2 = l.get(1);
    PVector l3 = l.get(2);
    PVector l4 = l.get(3);

    List<PVector> c = new ArrayList<PVector>(4);
    c.add(intersection(l1, l2));
    c.add(intersection(l2, l3));
    c.add(intersection(l3, l4));
    c.add(intersection(l4, l1));
    PVector c1 = c.get(0), c2 = c.get(1), c3 = c.get(2), c4 = c.get(3);
    
    
    
    fill(255, 128, 0, 80);
    quad(c1.x, c1.y, c2.x, c2.y, c3.x, c3.y, c4.x, c4.y);

    fill(255, 128, 0);
    stroke(204, 102, 0);
    for (PVector line : l) displayLine(line, w);
    for (PVector corner : c) displayCorner(corner);
    
    TwoDThreeD t = new TwoDThreeD(width,height);
    List<PVector> sorted = sortCorners(c);
    PVector p = t.get3DRotations(sorted);
    System.out.println("rx:"+degrees(p.x)+" , ry:"+degrees(p.y)+" , rz:"+degrees(p.z));
  }

  private void displayLine(PVector l, int w) {
    // Cartesian equation of a line: y = ax + b
    // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
    // => y = 0 : x = r / cos(phi)
    // => x = 0 : y = r / sin(phi)
    // compute the intersection of this line with the 4 borders of
    // the image
    float r = l.x;
    float phi = l.y;
    int x0 = 0;
    int y0 = (int) (r / sin(phi));
    int x1 = (int) (r / cos(phi));
    int y1 = 0;
    int x2 = w;
    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
    int y3 = w;
    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
    // Finally, plot the lines
    if (y0 > 0) {
      if (x1 > 0)
        line(x0, y0, x1, y1);
      else if (y2 > 0)
        line(x0, y0, x2, y2);
      else
        line(x0, y0, x3, y3);
    } else {
      if (x1 > 0) {
        if (y2 > 0)
          line(x1, y1, x2, y2);
        else
          line(x1, y1, x3, y3);
      } else
        line(x2, y2, x3, y3);
    }
  }

  private void displayCorner(PVector c) {
    ellipse(c.x, c.y, 10, 10);
  }
}