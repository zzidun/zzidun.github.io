---
title: C艹模板元编程初步
author: zzidun
date: 2022-01-22
tags: 编程学习
---

# integral_constant

```cpp
template<typename _Tp, _Tp __v>
struct integral_constant
{
    static constexpr _Tp                  value = __v;
    typedef _Tp                           value_type;
    typedef integral_constant<_Tp, __v>   type;
    constexpr operator value_type() const noexcept { return value; }
#if __cplusplus > 201103L

#define __cpp_lib_integral_constant_callable 201304

    constexpr value_type operator()() const noexcept { return value; }
#endif
};
```

# constexpr

在编译期需要用到的值,必须能够在编译期确定.

如果像是这样:

```cpp
int get_five() {return 5;}

int some_value[get_five() + 7];
```

因为`fet_five()+7`是一个需要在运行时才能确定的值.

而`somve_value`的大小必须要在编译期确定,所以以上代码会报错.

`C++11`有了`constexpr`.

可以如果函数符合某些条件,以至于能够在编译期就确定他的返回值,那么加上`constexpr`能够在编译期使用这个函数的返回值.

就像上面的代码可以改为

```shell
constexpr int get_five() {return 5;}

int some_value[get_five() + 7];
```

# __cpp_lib_integral_constant_callable

这个宏表示这个函数重载了`operator()`,至于为什么要把`operator()`写在`#if __cplusplus > 201103L`里面,我暂时不清楚.

# 成员

结构体定义了类型为`_Tp`的成员`value`,值为`__v`.

并且把`_Tp`定义为`value_type`,把这个结构体本身定义为`type`.

这些成员都是可以在编译期确定了,也就是可以写一个这样的代码:

```cpp
std::integral_constant<bool, true>::value_type the_bool
  = std::integral_constant<bool, true>::value;
```

这个代码虽然没啥卵用,但是这个用法是很有用的.

# operator value_type()

这个函数的作用是:当把这个结构体转成`value_type`类型时,实际上会返回这个函数的返回值.

类似的用法如下:

```cpp
struct sample{
    constexpr operator double() const noexcept { return 1.0；}
    constexpr operator float() const noexcept { return 2.0; }
};

int main()
{
    sample the_sample;
    std::cout << float(the_sample) << std::endl;
    std::cout << double(the_sample) << std::endl;
    return 0;
}

```

# value_type operator()()

如果有一个类实现了`operator()()`,我们可以将这个类实例化的对象当成一个函数来用.

把这个对象当成函数来使用时,他就会执行函数`operator()()`.

例如这样:

```cpp
struct sample {
    constexpr int operator()() const noexcept { return 0; }
    constexpr int operator()(int a) const noexcept { return 1; }
    constexpr int operator()(int a, int b) const noexcept { return 2; }
};

int main()
{
    sample the_sample;
    std::cout << the_sample() << std::endl;
    std::cout << the_sample(1) << std::endl;
    std::cout << the_sample(1,2) << std::endl;
    return 0;
}
```

知道这几个特性之后,这个结构体的作用就非常明显了.

# true_type和false_type

```cpp
/// The type used as a compile-time boolean with true value.
typedef integral_constant<bool, true>     true_type;

/// The type used as a compile-time boolean with false value.
typedef integral_constant<bool, false>    false_type;
```

C++预先定义了这两个结构体,其他很多地方用到.

这里我们细说`true_type`,他的表现如下

| 用法 | 效果 |
| --- | --- |
| `true_type().value` | 值`true` |
| `true_type::value_type` | 类型`bool` |
| `type` | 类型`integral_constant<bool, true>` |
| `bool(true_type())` | 值`true` |
| `true_type()()` | 值`true` |

再次强调,这里几个成员,要不就是`constexpr`变量和函数,要不就是`typedef`定义的类型.他们都可以在编译期确定.

# conditional

```cpp
template<bool _Cond, typename _Iftrue, typename _Iffalse>
    struct conditional
    { typedef _Iftrue type; };

// Partial specialization for false.
template<typename _Iftrue, typename _Iffalse>
    struct conditional<false, _Iftrue, _Iffalse>
    { typedef _Iffalse type; };
```

以上代码根据`bool _Cond`的值,来决定`conditional::type`.

先定义一个模板类,无论如何都把`type`定义为`_Iftrue`.

然后特化这个模板,当`_Cond`传入`false`的时候,把`type`定义为`_Iffalse`.



上述的`conditonal`的第一个模板参数`_Cond`其实很有说法.

如果我们直接传布尔值,或者传一个很简单的表达式,那就浪费了.

因此,C++定义了`__or_`, `__and_`等等结构体,来实现复杂的判断.

# \_\_or\_

```cpp
  template<typename...>
    struct __or_;

  template<>
    struct __or_<>
    : public false_type
    { };

  template<typename _B1>
    struct __or_<_B1>
    : public _B1
    { };

  template<typename _B1, typename _B2>
    struct __or_<_B1, _B2>
    : public conditional<_B1::value, _B1, _B2>::type
    { };

  template<typename _B1, typename _B2, typename _B3, typename... _Bn>
    struct __or_<_B1, _B2, _B3, _Bn...>
    : public conditional<_B1::value, _B1, __or_<_B2, _B3, _Bn...>>::type
    { };
```
这里细说`__or_`.

# \_\_or\_<\>

当我们不给`__or_`传模板参数时,他就会直接继承一个`false_type`.

也就是说以下代码:

```cpp
    std::__or_<> empty_or;
    std::cout << empty_or.value << std::endl;
```

会输出`0`.

# \_\_or\_<\_B1\>

当`__or_`接受一个模板参数的时候,他直接继承这个这个参数.

也就是如果这个参数继承了`true_type`,也就是`_B1::value`为`true`,那么`__or_`就会继承`_B1`,从而表现出`true_type`的特点.

同理,如果这个参数继承了`false_type`,那么`__or_`表现出`false_type`的特点.

这非常符合`or`的特征,当只接收一个布尔值时,计算结果就是这个布尔值.

# \_\_or\_<\_B1, \_B2\>

如果`_B1::value`为`true`,那么`conditional<_B1::value, _B1, _B2>::type`将会返回`_B1`,`__or_`直接继承`_B1`,无视`_B2`.

否则就继承`_B2`.

继承`_B2`之后,`__or_`的`value`取决于`_B2::value`.

这和`or`运算的表现一模一样.

此外,`stl`的源码中还有`__and_`等等用于逻辑运算的模板类.实现方法也类似.

到这里我们发现一个特点,模板元编程能够在编译期执行一些条件判断.

他不能像指令式编程那样一条条语句往下写,反而很像函数式编程.

可以通过上面的方法来组合各个类,编译器一顿推导之后,就会返回我们想要的值.
