$$
C = \frac{1}{N}\sum_{i}^{N}{||y_i - a^L(x_i)||^2}
$$

where $N$ - number of training samples, 

$y_i$ - ith expected output (as vector, each component 
is an expected output of corresponding node),

$x_i$ - ith input, 

$L$ - number of layers in the network,

$a^{L}(x)$ - output of $L$th layer when network received
$x$ as its input

$||a||$ - euclidean norm of the vector $a$:

$$
||a|| = \sqrt{a_1^2 +a_2^2 + a_3^2 + ... + a_n^2}
$$
