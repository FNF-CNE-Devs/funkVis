package funkin.vis.dsp;

class ComplexData {
	public var real:Float;
	public var imag:Float;

	public function new(real:Float, imag:Float) {
		this.real = real;
		this.imag = imag;
	}
}

@:forward(real, imag) @:notNull @:pure
abstract MutableComplex(ComplexData) from ComplexData from Complex to ComplexData {
	inline function new(real:Float, imag:Float) {
		this = new ComplexData(real, imag);
	}

	/**
		Makes a Complex number with the given Float as its real part and a zero imag part.
	**/
	@:from
	public static inline function fromReal(r:Float) {
		return new MutableComplex(r, 0);
	}

	@:from
	public static inline function fromImmutable(c:Complex) : MutableComplex {
		return c;//new MutableComplex(c.real, c.imag);
	}

	public inline function immutable() : Complex {
		return this;
	}

	/**
		Complex argument, in radians.
	**/
	public var angle(get,never) : Float;
	inline function get_angle() {
		return Math.atan2(this.imag, this.real);
	}

	/**
		Complex module.
	**/
	public var magnitude(get,never) : Float;
	inline function get_magnitude() {
		return Math.sqrt(this.real*this.real + this.imag*this.imag);
	}

	public inline function add(rhs:MutableComplex) : MutableComplex {
		this.real += rhs.real;
		this.imag += rhs.imag;
		return this;
	}

	public inline function sub(rhs:MutableComplex) : MutableComplex {
		this.real -= rhs.real;
		this.imag -= rhs.imag;
		return this;
	}

	// this might be wrong, this seems to be wrong?
	public inline function mult(rhs:MutableComplex) : MutableComplex {
		var real = this.real*rhs.real - this.imag*rhs.imag;
		var imag = this.real*rhs.imag + this.imag*rhs.real;
		this.real = real;
		this.imag = imag;
		return this;
	}

	/**
		Returns the complex conjugate.
	**/
	public inline function conj() : MutableComplex {
		this.imag = -this.imag;
		return this;
	}

	/**
		Multiplication by a real factor.
	**/
	public inline function scale(k:Float) : MutableComplex {
		this.real *= k;
		this.imag *= k;
		return this;
	}

	public inline function copy() : MutableComplex {
		return new MutableComplex(this.real, this.imag);
	}

	/**
		The imaginary unit.
	**/
	public static var im(get,never):MutableComplex;
	static inline function get_im() {
		return new MutableComplex(0, 1);
	}

	/**
		The complex zero.
	**/
	public static var zero(get,never):MutableComplex;
	static inline function get_zero() {
		return new MutableComplex(0, 0);
	}

	/**
		Computes the complex exponential `e^(iw)`.
	**/
	public static inline function exp(w:Float) {
		return new MutableComplex(Math.cos(w), Math.sin(w));
	}
}

/**
	Complex number representation.
**/
@:forward(real, imag) @:notNull @:pure
abstract Complex(ComplexData) from ComplexData to ComplexData {
	public inline function new(real:Float, imag: Float)
		this = new ComplexData(real, imag);

	/**
		Makes a Complex number with the given Float as its real part and a zero imag part.
	**/
	@:from
	public static inline function fromReal(r:Float) {
		return new Complex(r, 0);
	}

	@:from
	public static inline function fromMutable(c:MutableComplex) : Complex {
		return new Complex(c.real, c.imag);
	}

	/**
		Complex argument, in radians.
	**/
	public var angle(get,never) : Float;
	inline function get_angle() {
		return Math.atan2(this.imag, this.real);
	}

	/**
		Complex module.
	**/
	public var magnitude(get,never) : Float;
	inline function get_magnitude() {
		return Math.sqrt(this.real*this.real + this.imag*this.imag);
	}

	@:op(A + B)
	public inline function add(rhs:Complex) : Complex {
		return new Complex(this.real + rhs.real, this.imag + rhs.imag);
	}

	@:op(A - B)
	public inline function sub(rhs:Complex) : Complex {
		return new Complex(this.real - rhs.real, this.imag - rhs.imag);
	}

	@:op(A * B)
	public inline function mult(rhs:Complex) : Complex {
		return new Complex(
			this.real*rhs.real - this.imag*rhs.imag,
			this.real*rhs.imag + this.imag*rhs.real
		);
	}

	/**
		Returns the complex conjugate, does not modify this object.
	**/
	public inline function conj() : Complex {
		return new Complex(this.real, -this.imag);
	}

	/**
		Multiplication by a real factor, does not modify this object.
	**/
	public inline function scale(k:Float) : Complex {
		return new Complex(this.real * k, this.imag * k);
	}

	public inline function copy() : Complex {
		return new Complex(this.real, this.imag);
	}

	/**
		The imaginary unit.
	**/
	public static final im = new Complex(0, 1);

	/**
		The complex zero.
	**/
	public static final zero = new Complex(0, 0);

	/**
		Computes the complex exponential `e^(iw)`.
	**/
	public static inline function exp(w:Float) {
		return new Complex(Math.cos(w), Math.sin(w));
	}
}
