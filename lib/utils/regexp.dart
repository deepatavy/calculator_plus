RegExp invalidCalculatorRegex = RegExp(
  r'^\s*'
  r'[^0-9+\-*/().\s]' // Match any character that is not a number, operator, parentheses, dot, or whitespace
  r'\s*$',
);