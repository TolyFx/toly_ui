// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-23
// Contact Me:  1981462002@qq.com

void main() {
  Point p0 = Point();
  move(p0);
  print(p0);
}

void move(Point p){
  p = Point();
  p.x =1;
  p.y =1;
}

class Point {
  int x = 0;
  int y = 0;

  @override
  String toString() {
    return 'Point{x: $x, y: $y}';
  }
}
