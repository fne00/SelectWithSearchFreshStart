import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_components/angular_components.dart';
import 'dart:html';
import 'dart:async';




@Component(
  selector: 'simple_single_select',
  styleUrls: ['simple_single_select_with_search_component.css'],
  templateUrl: 'simple_single_select_with_search_component.html',
  directives: [
    MaterialDropdownSelectComponent,
    MaterialSelectSearchboxComponent,
    DropdownSelectValueAccessor,
    MaterialSelectDropdownItemComponent,
    MultiDropdownSelectValueAccessor,
    NgModel,
    NgIf,
    NgFor,
    DropdownButtonComponent
  ],
  providers: const [popupBindings, materialProviders],

)

class SimpleSingleSelectWithSearch implements OnInit{
  static const List<Language> _languagesList = <Language>[
    Language('en-US', 'US English'),
    Language('en-UK', 'UK English'),
    Language('fr-CA', 'Canadian English'),
    Language('af', 'Afrikaans'),
    Language('sq', 'Albanian'),
    Language('ar', 'Arabic'),
    Language('hy', 'Armenian'),
    Language('az', 'Azerbaijani'),
    Language('eu', 'Basque'),
    Language('be', 'Belarusian'),
    Language('bn', 'Bengali'),
    Language('bs', 'Bosnian'),
    Language('bg', 'Bulgarian'),
    Language('ca', 'Catalan'),
    Language('ceb', 'Cebuano'),
    Language('zh-CN', 'Chichewa'),
    Language('zh-TW', 'Chinese'),
    Language('ny', 'Chinese (Simplified)'),
    Language('zh', 'Chinese (Traditional)'),
    Language('hr', 'Croatian'),
    Language('cs', 'Czech'),
    Language('da', 'Danish'),
    Language('nl', 'Dutch'),
    Language('en', 'English'),
    Language('eo', 'Esperanto'),
    Language('et', 'Estonian'),
    Language('tl', 'Filipino'),
    Language('fi', 'Finnish'),
    Language('fr', 'French'),
    Language('gl', 'Galician'),
    Language('ka', 'Georgian'),
    Language('de', 'German')
  ];


  static List<RelativePosition> _popupPositionsAboveInput = const [
    RelativePosition.AdjacentTopLeft,
    RelativePosition.AdjacentTopRight
  ];
  static List<RelativePosition> _popupPositionsBelowInput = const [
    RelativePosition.AdjacentBottomLeft,
    RelativePosition.AdjacentBottomRight
  ];

  static ItemRenderer _displayNameRenderer =
      (item) => (item as HasUIDisplayName).uiDisplayName;


  // Specifying an itemRenderer avoids the selected item from knowing how to
  // display itself.
  static ItemRenderer _itemRenderer = newCachingItemRenderer<Language>(
          (language) => "${language.label} (${language.code})");


  /// Languages to choose from.
  ExampleSelectionOptions languageListOptions =
  ExampleSelectionOptions(_languagesList);


  StringSelectionOptions<Language> get languageOptions =>
       languageListOptions;

  /// Single Selection Model
  final SelectionModel<Language> singleSelectModel =
  SelectionModel.single(selected: _languagesList[1]);

  /// Label for the button for single selection.
  String get singleSelectLanguageLabel =>
      singleSelectModel.selectedValues.isNotEmpty
          ? itemRenderer(singleSelectModel.selectedValues.first)
          : 'Select Language';



  final SelectionModel<String> popupPositionSelection =
  SelectionModel<String>.multi();
  final StringSelectionOptions popupPositionOptions =
  StringSelectionOptions<String>(['Auto', 'Above', 'Below']);
  String get popupPositionButtonText =>
      popupPositionSelection.selectedValues.isNotEmpty
          ? popupPositionSelection.selectedValues.first
          : 'Auto';

  final SelectionModel<String> slideSelection = SelectionModel<String>.multi();
  final StringSelectionOptions slideOptions =
  StringSelectionOptions<String>(['Default', 'x', 'y']);
  String get slideButtonText => slideSelection.selectedValues.isNotEmpty
      ? slideSelection.selectedValues.first
      : 'Default';



  List<RelativePosition> get preferredPositions {
    switch (popupPositionButtonText) {
      case 'Above':
        return _popupPositionsAboveInput;
      case 'Below':
        return _popupPositionsBelowInput;
    }
    return RelativePosition.overlapAlignments;
  }

  String get slide => slideSelection.selectedValues.isNotEmpty &&
      slideSelection.selectedValues.first != 'Default'
      ? slideSelection.selectedValues.first
      : null;

  String get singleSelectedLanguage =>
      singleSelectModel.selectedValues.isNotEmpty
          ? singleSelectModel.selectedValues.first.uiDisplayName
          : null;


  ItemRenderer<Language> get itemRenderer => _displayNameRenderer;



  @ViewChild(MaterialSelectSearchboxComponent)
  MaterialSelectSearchboxComponent searchbox;

  void onDropdownVisibleChange(bool visible) {
    if (visible) {
      // TODO(google): Avoid using Timer.run.
      Timer.run(() {
        searchbox.focus();
      });
    }
  }

  Language selectionValue;
  List<Language> selectionValues = [];
  String get selectionValuesLabel {
    final size = selectionValues.length;
    if (size == 0) {
      return 'Select Languages';
    } else if (size == 1) {
      return itemRenderer(selectionValues.first);
    } else {
      return "${itemRenderer(selectionValues.first)} + ${size - 1} more";
    }
  }

  String selectionOption;

  void alert(String message) => window.alert(message);

  String languageButtonLabel = 'Select Language';
  List<Language> get languagesList => _languagesList;

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
  }

}

class Language implements HasUIDisplayName {
  final String code;
  final String label;
  const Language(this.code, this.label);
  @override
  String get uiDisplayName => label;

  @override
  String toString() => uiDisplayName;
}


/// If the option does not support toString() that shows the label, the
/// toFilterableString parameter must be passed to StringSelectionOptions.
class ExampleSelectionOptions extends StringSelectionOptions<Language>
    implements Selectable<Language> {
  ExampleSelectionOptions(List<Language> options)
      : super(options,
      toFilterableString: (Language option) => option.toString());
  ExampleSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups)
      : super.withOptionGroups(optionGroups,
      toFilterableString: (Language option) => option.toString());
  @override
  SelectableOption getSelectable(Language item) =>
      item is Language && item.code.contains('en')
          ? SelectableOption.Disabled
          : SelectableOption.Selectable;
}
