The idea is taken from here: 
https://fsix.github.io/mnist/Deskewing.html

It is an amazing article, but it doesn't explain the derivation
of the formula for $\alpha$. This file presents a derivation of the formula

The Python code for `moments()` function is very useful
to find the original formulas. You can also see Wikipedia
articles on [covariance](https://en.wikipedia.org/wiki/Covariance)
and [variance](https://en.wikipedia.org/wiki/Variance)

(Here I use $a$ instead of $\alpha$ - quicker to type)

$X$ - set of x coordinates of the original image

$X'$ - set of x coordinated of its skewed version

$Y$, $Y'$ - some, but with y coordinates

$p_i$ - intensity of $i$th pixel of the original image. Images are 2D, but we can index their pixels
in 1D

$p_i'$ - intensity of the $i$th pixel of the skewed
image

$x_i, x_i'$ - $i$th element of $X$ and $X'$ respectively. Same for $y_i$ and $y_i'$

$N$ - total number of pixels

$$
cov(X', Y') = \frac{\sum_{i}^{N}{(x'_i - m'_x)(y'_i - m'_y) * p'_i}}{N}
$$

Since we apply skew (shear) transform to x-coordinates:

$$
x' = x + ay \\
y' = y
$$

So

$$
cov(X', Y') = \frac{\sum_{i}^{N}{(x_i + ay_i - m_x - am_y)(y_i - m_y) * p'_i}}{N} =
$$

$$
\frac{\sum_{i}^{N}{((x_i - m_x) + (ay_i - am_y))(y_i - m_y) * p'_i}}{N} =
$$

$$
\frac{\sum_{i}^{N}{(x_i - m_x)(y_i - m_y) * p'_i}}{N} + 
\frac{\sum_{i}^{N}{a(y_i - m_y)^2 * p'_i}}{N}
$$

Since $p'_i = p_i$ (skew transform does not change the brightness
of the pixel) and 

$$
cov(X, Y) = \frac{\sum_{i}^{N}{(x_i - m_x)(y_i - m_y) * p_i}}{N}
$$

...and

$$
var(Y) = \frac{\sum_{i}^{N}{a(y_i - m_y)^2 * p_i}}{N}
$$

...the last formula is equivalent to 

$$
cov(X, Y) + a * var(Y)
$$

So we can say that (1)
$$
cov(X', Y') = cov(X, Y) + a * var(Y)
$$ 


We can compute $cov(X', Y')$ of the new image. We
can also compute $var(Y)$: since our skew transform
doesn't change y coordinates, $var(Y)$ = $var(Y')$,
and we can compute $var(Y')$ from the given image

If we divide both sides of (1) by $var(Y')$ = $var(Y)$, we get:

$$
\frac{cov(X', Y')}{var(Y')} = \frac{cov(X, Y)}{var(Y)} + a
$$

Since we assume that the original image is not skewed, its
covariance will be nearly $0$: 

$$
cov(X, Y) \approx 0
$$

So the fraction above approximates $a$

$$
\frac{cov(X', Y')}{var(Y')} \approx a
$$
