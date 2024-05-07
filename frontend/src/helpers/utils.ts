const gcd = (a: number, b: number) => (a ? gcd(b % a, a) : b);

const lcm = (a: number, b: number) => (a * b) / gcd(a, b);

export { lcm };
