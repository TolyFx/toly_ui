
##### 7.属性一览

> 注意一点: Wrapper的区域是由父容器控制的，Wrapper本身并不承担定尺寸职责。

属性名 | 类型| 默认值 | 简介 
---|---|---|---
color | Color | Colors.green | 框框颜色
spineType | SpineType | SpineType.left | 尖角边枚举
child | Widget | null | 子组件
angle | double | 75 | 针尖夹角
spineHeight | double | 10 | 尖角高度
offset | double | 15 | 偏移量
formEnd | bool | false | 是否从尾部偏移
elevation | double | null | 影深
shadowColor | Color | Colors.grey | 阴影颜色
strokeWidth | double | null | 边线宽
padding | EdgeInsets | EdgeInsets.all(5) | 内边距
radius | double | 5 | 圆角半径


##### 2. 针尖属性控制

> 通过针尖的开角和高度能实现对尖角更细致的控制   
通过offset进行位移，考虑到有可能从尾向前偏移，使用formEnd控制，如下[图四]

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9cd2425e1d08454582012950cf1a2393~tplv-k3u1fbpfcp-zoom-1.image)

属性名 | 类型| 默认值 | 简介 
---|---|---|---
angle | double | 75 | 针尖夹角
spineHeight | double | 10 | 尖角高度
offset | double | 15 | 偏移量
formEnd | bool | false | 是否从尾部偏移

```dart
Wrapper(
  color: Color(0xff95EC69),
  spineType: SpineType.bottom,
  spineHeight: 20,
  angle: 45,
  offset: 15,
  fromEnd: false,
  child: Text("张风捷特烈 " * 5),
)
```

---

##### 3. 框阴影

> 注意: 只有当elevation不为空的时候才能有阴影

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/15ff4c2bf1c64d5ea000d6a1addee97b~tplv-k3u1fbpfcp-zoom-1.image)

属性名 | 类型| 默认值 | 简介 
---|---|---|---
elevation | double | null | 影深
shadowColor | Color | Colors.grey | 阴影颜色


```dart
Wrapper(
  color: Colors.white,
  spineType: SpineType.right,
  elevation: 1,
  shadowColor: Colors.grey.withAlpha(88),
  child: Text("张风捷特烈 " * 5),
)
```

---

##### 4. 边线边距
>注意: 当strokeWidth不为空时，会变为边线模式

![](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/34496eae7175412ead9f707cb37406d2~tplv-k3u1fbpfcp-zoom-1.image)

属性名 | 类型| 默认值 | 简介 
---|---|---|---
strokeWidth | double | null | 边线宽
padding | EdgeInsets | EdgeInsets.all(5) | 内边距




```dart
Wrapper(
  formEnd: true,
  padding: EdgeInsets.all(10),
  color: Colors.yellow,
  offset: 60,
  strokeWidth: 2,
  spineType: SpineType.bottom,
  child: Text("张风捷特烈 " * 5),
)
```
---

##### 5. `Wrapper.just`

> 提供无针尖的构造方法，实现类似包裹的效果,可以包裹任意组件。

![](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ca2212fe5d6d453aae8536bfe11777aa~tplv-k3u1fbpfcp-zoom-1.image)


```dart
Wrapper.just(
  padding: EdgeInsets.all(2),
  color: Color(0xff5A9DFF),
  child: Text(
    "Lv3",
    style: TextStyle(color: Colors.white),
  ),
)
```

---

##### 6. 尖端路径构造器
> 为了让组件更灵活,我将尖端路径的构造提取出来，暴露接口，并提供默认路径  
这样就可以自己定制尖端图形，提高拓展性。路径构造器，返回Path对象，回调尖端所在的矩形区域range,类型spineType，还回调了Canvas以供绘制。

![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/31e8734c06f84d30b1a46c91a99e565f~tplv-k3u1fbpfcp-zoom-1.image)

```dart
Wrapper(
    spinePathBuilder: _spinePathBuilder,
    strokeWidth: 1.5,
    color: Color(0xff95EC69),
    spineType: SpineType.bottom,
    child: Text("张风捷特烈 " * 5)
),

Path _spinePathBuilder2(Canvas canvas, SpineType spineType, Rect range) {
  return Path()
    ..addOval(Rect.fromCenter(center: range.center, width: 10, height: 10));
}
```


---