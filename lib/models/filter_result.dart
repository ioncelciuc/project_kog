import 'package:project_kog/models/filter.dart';

class FilterResult {
  double currentMinAtkSliderValue;
  double currentMaxAtkSliderValue;

  double currentMinDefSliderValue;
  double currentMaxDefSliderValue;

  double currentMinLvlSliderValue;
  double currentMaxLvlSliderValue;

  double currentMinScaleSliderValue;
  double currentMaxScaleSliderValue;

  double currentMinLinkSliderValue;
  double currentMaxLinkSliderValue;

  List<Filter> filterList;

  FilterResult(){
    filterList = new List<Filter>();
    currentMinAtkSliderValue = 0;
    currentMaxAtkSliderValue = 0;

    currentMinDefSliderValue = 0;
    currentMaxDefSliderValue = 0;

    currentMinLvlSliderValue = 0;
    currentMaxLvlSliderValue = 0;

    currentMinScaleSliderValue = 0;
    currentMaxScaleSliderValue = 0;

    currentMinLinkSliderValue = 0;
    currentMaxLinkSliderValue = 0;
  }

  FilterResult.parameterConstructor(
      {this.currentMinAtkSliderValue,
      this.currentMaxAtkSliderValue,
      this.currentMinDefSliderValue,
      this.currentMaxDefSliderValue,
      this.currentMinLvlSliderValue,
      this.currentMaxLvlSliderValue,
      this.currentMinScaleSliderValue,
      this.currentMaxScaleSliderValue,
      this.currentMinLinkSliderValue,
      this.currentMaxLinkSliderValue,
      this.filterList});
}
