#import "../template/elteikthesis.typ": *

= Fejlesztői dokumentáció <ch:impl>

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis nibh leo, dapibus in elementum nec, aliquet id sem. Suspendisse potenti. Nullam sit amet consectetur nibh. Donec scelerisque varius turpis at tincidunt.


== Tételek, definíciók, megjegyzések

#definition[
Mauris tristique sollicitudin ultrices. Etiam tristique quam sit amet metus dictum imperdiet. Nunc id lorem sed nisl pulvinar aliquet vitae quis arcu. Morbi iaculis eleifend porttitor.
]

Maecenas rutrum eros sem, pharetra interdum nulla porttitor sit amet. In vitae viverra ante. Maecenas sit amet placerat orci, sed tincidunt velit. Vivamus mattis, enim vel suscipit elementum, quam odio venenatis elit, et mollis nulla nunc a risus. Praesent purus magna, tristique sed lacus sit amet, convallis malesuada magna. Phasellus faucibus varius purus, nec tristique enim porta vitae.

#theorem[
Nulla finibus ante vel arcu tincidunt, ut consectetur ligula finibus. Mauris mollis lectus sed ipsum bibendum, ac ultrices erat dictum. Suspendisse faucibus euismod lacinia. Etiam vel odio ante.
]
#proof[
Etiam pulvinar nibh quis massa auctor congue. Pellentesque quis odio vitae sapien molestie vestibulum sit amet et quam. Pellentesque vel dui eget enim hendrerit finibus at sit amet libero. Quisque sollicitudin ultrices enim, nec porta magna imperdiet vitae. Cras condimentum nunc dui.
]

Donec dapibus sodales ante, at scelerisque nunc laoreet sit amet. Mauris porttitor tincidunt neque, vel ullamcorper neque pulvinar et. Integer eu lorem euismod, faucibus lectus sed, accumsan felis.

#remark[
Nunc ornare mi at augue vulputate, eu venenatis magna mollis. Nunc sed posuere dui, et varius nulla. Sed mollis nibh augue, eget scelerisque eros ornare nec. Praesent porta, metus eget eleifend consequat, eros ligula eleifend ex, a pellentesque mi est vitae urna. Vivamus turpis nunc, iaculis non leo eget, mattis vulputate tellus.
]

Fusce in aliquet neque, in pretium sem. Donec tincidunt tellus id lectus pretium fringilla. Nunc faucibus, erat pretium tempus tempor, tortor mi fringilla neque, ac congue ex dui vitae mauris. Donec pretium et quam a cursus.

#note[
Aliquam vehicula luctus mi a pretium. Nulla quam neque, maximus nec velit in, aliquam mollis tortor. Aliquam erat volutpat. Curabitur vitae laoreet turpis. Integer id diam ligula.
]

Ut sollicitudin tempus urna et mollis. Aliquam et aliquam turpis, sed fermentum mauris. Nulla eget ex diam. Donec eget tellus pharetra, semper neque eget, rutrum diam.

=== Egyenletek, matematika

Duis suscipit ipsum nec urna blandit, $2 + 2 = 4$ pellentesque vehicula quam fringilla. Vivamus euismod, lectus sit amet euismod viverra, dolor metus consequat sapien, ut hendrerit nisl nulla id nisi. Nam in leo eu quam sollicitudin semper a quis velit.

#math.equation(block: true, numbering: none, $a^2 + b^2 = c^2$)

Phasellus mollis, elit sed convallis feugiat, dolor quam dapibus nibh, suscipit consectetur lacus risus quis sem. Vivamus scelerisque porta odio, vitae euismod dolor accumsan ut.

In mathematica, identitatem Euleri (equation est scriptor vti etiam notum) sit aequalitatem @eq:euler:
$ e^(i times pi) + 1 = 0 $ <eq:euler>

Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nullam pulvinar purus at pharetra elementum.
Aequationes adsignans aequationis signum:
#align-equations(
  ($A$, $= (pi r^2)/2$),
  ($$, $= 1/2 pi r^2$),
)

Proin tempor risus a efficitur condimentum. Cras lobortis ligula non sollicitudin euismod. Fusce non pellentesque nibh, non elementum tellus.
Omissa numeratione aliquarum aequationum:
#align-equations(
  ($f(u)$, $= sum_(j=1)^n x_j f(u_j)$, false),
  ($$, $= sum_(j=1)^n x_j sum_(i=1)^m a_(i j) v_i$, false),
  ($$, $= sum_(j=1)^n sum_(i=1)^m a_(i j) x_j v_i$),
)

== Forráskódok

Nulla sodales purus id mi consequat, eu venenatis odio pharetra. Cras a arcu quam. Suspendisse augue risus, pulvinar a turpis et, commodo aliquet turpis. Nulla aliquam scelerisque mi eget pharetra. Mauris sed posuere elit, ac lobortis metus. Proin lacinia sit amet diam sed auctor. Nam viverra orci id sapien sollicitudin, a aliquam lacus suscipit. Quisque ac tincidunt leo @src:cpp[]. és @src:csharp:

#figure(
```cpp
#include <stdio>

int main()
{
	int c;
	std::cout << "Hello World!" << std::endl;

	std::cout << "Press any key to exit." << std::endl;
	std::cin >> c;

	return 0;
}
```,
  caption: [Hello World in C++],
) <src:cpp>

#figure(
```cs
using System;
namespace HelloWorld
{
	class Hello
	{
		static void Main()
		{
			Console.WriteLine("Hello World!");

			Console.WriteLine("Press any key to exit.");
			Console.ReadKey();
		}
	}
}
```,
  caption: [Hello World in C\#],
) <src:csharp>

=== Algoritmusok

Az @alg:ibb egy általános elágazás és korlátozás algoritmust (_Branch and Bound algorithm_) mutat be. A @step:selrule[lépésben] egy megfelelő kiválasztási szabályt kell alkalmazni.
Példa forrása: #link("https://www.inf.u-szeged.hu/actacybernetica/")[Acta Cybernetica (ez egy hiperlink)].

#algorithm(caption: [A general interval B&B algorithm])[
  *#underline[Funct]* IBB($S,f$)
  #algorithmic(
    (0, [Set the working list $cal(L)_W$ := ${S}$ and the final list $cal(L)_Q$ := ${}$]),
    (0, [*while* ( $cal(L)_W != emptyset$ ) *do*]),
    (1, [Select an interval $X$ from $cal(L)_W$], [Selection rule], <step:selrule>),
    (1, [Compute $l b f(X)$], [Bounding rule]),
    (1, [*if* $X$ cannot be eliminated *then*], [Elimination rule]),
    (2, [Divide $X$ into $X^j, med j=1,dots, p$, subintervals], [Division rule]),
    (2, [*for* $j=1,dots,p$ *do*]),
    (3, [*if* $X^j$ satisfies the termination criterion *then*], [Termination rule]),
    (4, [Store $X^j$ in $cal(L)_W$]),
    (3, [*else*]),
    (4, [Store $X^j$ in $cal(L)_W$]),
    (3, [*end if*]),
    (2, [*end for*]),
    (1, [*end if*]),
    (0, [*end while*]),
    (0, [*return* $cal(L)_Q$]),
  )
] <alg:ibb>
