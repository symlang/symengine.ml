let class_count = 100
type class_name = 
  | Integer  (* INTEGER *)
  | Rational  (* RATIONAL *)
  | Complex  (* COMPLEX *)
  | ComplexDouble  (* COMPLEX_DOUBLE *)
  | RealMPFR  (* REAL_MPFR *)
  | ComplexMPC  (* COMPLEX_MPC *)
  | RealDouble  (* REAL_DOUBLE *)
  | Infty  (* INFTY *)
  | NaN  (* NOT_A_NUMBER *)
  | URatPSeriesPiranha  (* URATPSERIESPIRANHA *)
  | UPSeriesPiranha  (* UPSERIESPIRANHA *)
  | URatPSeriesFlint  (* URATPSERIESFLINT *)
  | NumberWrapper  (* NUMBER_WRAPPER *)
  | Symbol  (* SYMBOL *)
  | Dummy  (* DUMMY *)
  | Mul  (* MUL *)
  | Add  (* ADD *)
  | Pow  (* POW *)
  | UIntPoly  (* UINTPOLY *)
  | MIntPoly  (* MINTPOLY *)
  | URatPoly  (* URATPOLY *)
  | UExprPoly  (* UEXPRPOLY *)
  | MExprPoly  (* MEXPRPOLY *)
  | UIntPolyPiranha  (* UINTPOLYPIRANHA *)
  | URatPolyPiranha  (* URATPOLYPIRANHA *)
  | UIntPolyFlint  (* UINTPOLYFLINT *)
  | URatPolyFlint  (* URATPOLYFLINT *)
  | GaloisField  (* GALOISFIELD *)
  | UnivariateSeries  (* UNIVARIATESERIES *)
  | Log  (* LOG *)
  | Conjugate  (* CONJUGATE *)
  | Constant  (* CONSTANT *)
  | Sign  (* SIGN *)
  | Floor  (* FLOOR *)
  | Ceiling  (* CEILING *)
  | Sin  (* SIN *)
  | Cos  (* COS *)
  | Tan  (* TAN *)
  | Cot  (* COT *)
  | Csc  (* CSC *)
  | Sec  (* SEC *)
  | ASin  (* ASIN *)
  | ACos  (* ACOS *)
  | ASec  (* ASEC *)
  | ACsc  (* ACSC *)
  | ATan  (* ATAN *)
  | ACot  (* ACOT *)
  | ATan2  (* ATAN2 *)
  | Sinh  (* SINH *)
  | Csch  (* CSCH *)
  | Cosh  (* COSH *)
  | Sech  (* SECH *)
  | Tanh  (* TANH *)
  | Coth  (* COTH *)
  | ASinh  (* ASINH *)
  | ACsch  (* ACSCH *)
  | ACosh  (* ACOSH *)
  | ATanh  (* ATANH *)
  | ACoth  (* ACOTH *)
  | ASech  (* ASECH *)
  | LambertW  (* LAMBERTW *)
  | Zeta  (* ZETA *)
  | Dirichlet_eta  (* DIRICHLET_ETA *)
  | KroneckerDelta  (* KRONECKERDELTA *)
  | LeviCivita  (* LEVICIVITA *)
  | Erf  (* ERF *)
  | Erfc  (* ERFC *)
  | Gamma  (* GAMMA *)
  | PolyGamma  (* POLYGAMMA *)
  | LowerGamma  (* LOWERGAMMA *)
  | UpperGamma  (* UPPERGAMMA *)
  | LogGamma  (* LOGGAMMA *)
  | Beta  (* BETA *)
  | FunctionSymbol  (* FUNCTIONSYMBOL *)
  | FunctionWrapper  (* FUNCTIONWRAPPER *)
  | Derivative  (* DERIVATIVE *)
  | Subs  (* SUBS *)
  | Abs  (* ABS *)
  | Max  (* MAX *)
  | Min  (* MIN *)
  | EmptySet  (* EMPTYSET *)
  | FiniteSet  (* FINITESET *)
  | Interval  (* INTERVAL *)
  | ConditionSet  (* CONDITIONSET *)
  | Union  (* UNION *)
  | Complement  (* COMPLEMENT *)
  | ImageSet  (* IMAGESET *)
  | Piecewise  (* PIECEWISE *)
  | UniversalSet  (* UNIVERSALSET *)
  | Contains  (* CONTAINS *)
  | BooleanAtom  (* BOOLEAN_ATOM *)
  | Not  (* NOT *)
  | And  (* AND *)
  | Or  (* OR *)
  | Xor  (* XOR *)
  | Equality  (* EQUALITY *)
  | Unequality  (* UNEQUALITY *)
  | LessThan  (* LESSTHAN *)
  | StrictLessThan  (* STRICTLESSTHAN *)
let id_of_class_name = function
  | Integer -> 1
  | Rational -> 2
  | Complex -> 3
  | ComplexDouble -> 4
  | RealMPFR -> 5
  | ComplexMPC -> 6
  | RealDouble -> 7
  | Infty -> 8
  | NaN -> 9
  | URatPSeriesPiranha -> 10
  | UPSeriesPiranha -> 11
  | URatPSeriesFlint -> 12
  | NumberWrapper -> 13
  | Symbol -> 14
  | Dummy -> 15
  | Mul -> 16
  | Add -> 17
  | Pow -> 18
  | UIntPoly -> 19
  | MIntPoly -> 20
  | URatPoly -> 21
  | UExprPoly -> 22
  | MExprPoly -> 23
  | UIntPolyPiranha -> 24
  | URatPolyPiranha -> 25
  | UIntPolyFlint -> 26
  | URatPolyFlint -> 27
  | GaloisField -> 28
  | UnivariateSeries -> 29
  | Log -> 30
  | Conjugate -> 31
  | Constant -> 32
  | Sign -> 33
  | Floor -> 34
  | Ceiling -> 35
  | Sin -> 36
  | Cos -> 37
  | Tan -> 38
  | Cot -> 39
  | Csc -> 40
  | Sec -> 41
  | ASin -> 42
  | ACos -> 43
  | ASec -> 44
  | ACsc -> 45
  | ATan -> 46
  | ACot -> 47
  | ATan2 -> 48
  | Sinh -> 49
  | Csch -> 50
  | Cosh -> 51
  | Sech -> 52
  | Tanh -> 53
  | Coth -> 54
  | ASinh -> 55
  | ACsch -> 56
  | ACosh -> 57
  | ATanh -> 58
  | ACoth -> 59
  | ASech -> 60
  | LambertW -> 61
  | Zeta -> 62
  | Dirichlet_eta -> 63
  | KroneckerDelta -> 64
  | LeviCivita -> 65
  | Erf -> 66
  | Erfc -> 67
  | Gamma -> 68
  | PolyGamma -> 69
  | LowerGamma -> 70
  | UpperGamma -> 71
  | LogGamma -> 72
  | Beta -> 73
  | FunctionSymbol -> 74
  | FunctionWrapper -> 75
  | Derivative -> 76
  | Subs -> 77
  | Abs -> 78
  | Max -> 79
  | Min -> 80
  | EmptySet -> 81
  | FiniteSet -> 82
  | Interval -> 83
  | ConditionSet -> 84
  | Union -> 85
  | Complement -> 86
  | ImageSet -> 87
  | Piecewise -> 88
  | UniversalSet -> 89
  | Contains -> 90
  | BooleanAtom -> 91
  | Not -> 92
  | And -> 93
  | Or -> 94
  | Xor -> 95
  | Equality -> 96
  | Unequality -> 97
  | LessThan -> 98
  | StrictLessThan -> 99
