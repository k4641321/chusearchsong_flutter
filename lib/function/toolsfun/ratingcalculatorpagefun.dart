double calculatorRating({required String scorestr, required String diffstr}) {
  double score = double.parse(scorestr);
  double diff = double.parse(diffstr);
  double result;
  //理论
  // if (score >= 1010000) {
  //   result = diff + 2.25;
  // } //SSS+
  // else
  if (score <= 1010000 && score >= 1009000) {
    result = diff + 2.15;
    // result = diff + 2.15 + (score - 1009000) * 0.0001;
  } //SSS
  else if (score < 1009000 && score >= 1007500) {
    result = diff + 2.0 + (score - 1007500) / 100 * 0.01;
    // result = diff + 2.0 + (score - 1007500) * 0.0001;
  } //SS+
  else if (score < 1007500 && score >= 1005000) {
    result = diff + 1.5 + (score - 1005000) / 50 * 0.01;
    // result = diff + 1.5 + (score - 1005000) * 0.0002;
  } //SS
  else if (score < 1005000 && score >= 1000000) {
    result = diff + 1.0 + (score - 1000000) / 100 * 0.01;
    // result = diff + 1.0 + (score - 1000000) * 0.0001;
  } //S+
  else if (score < 1000000 && score >= 990000) {
    result = diff + 0.6 + (score - 990000) / 250 * 0.01;
  } //S
  else if (score < 990000 && score >= 975000) {
    result = diff + (score - 975000) / 250 * 0.01;
  } //AAA
  else if (score < 975000 && score >= 950000) {
    result = diff - 1.67 + (score - 950000) / 150 * 0.01;
  } //AA
  else if (score < 950000 && score >= 925000) {
    result = diff - 3.34 + (score - 925000) / 150 * 0.01;
  } //A
  else if (score < 925000 && score >= 900000) {
    result = diff - 5.0 + (score - 900000) / 150 * 0.01;
  } //BBB
  else if (score < 900000 && score >= 800000) {
    result = (diff - 5.0) / 2 + (score - 800000) / (2000 / (diff - 5)) * 0.01;
  } //C - BB
  else if (score < 800000 && score >= 500000) {
    result = 0 + (score - 500000) / (6000 / (diff - 5)) * 0.01;
  } //C以下
  else if (score < 500000) {
    result = 0;
  } else {
    result = 0;
  }
  return result;
}
