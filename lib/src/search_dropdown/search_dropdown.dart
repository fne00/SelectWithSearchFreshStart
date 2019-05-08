import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/laminate/enums/alignment.dart';
import 'package:angular_components/laminate/popup/module.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_select_dropdown_item.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/material_select/material_select_searchbox.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/model/ui/display_name.dart';
import 'package:angular_components/model/ui/has_factory.dart';


import 'search_dropdown.template.dart' as demo;
import 'search_dropdown_service.dart';

@Component(
  selector: 'search-dropdown',
  // popupBindings should ideally be in a top level or root component.
  // In demos, this is the top level/root component.
  providers: [popupBindings, ClassProvider(DropdownService)],
  directives: [
    materialInputDirectives,
    MaterialCheckboxComponent,
    MaterialDropdownSelectComponent,
    MaterialSelectSearchboxComponent,
    DropdownSelectValueAccessor,
    MultiDropdownSelectValueAccessor,
    MaterialSelectDropdownItemComponent,
    NgModel,
    NgIf,
    NgFor,
    DropdownButtonComponent,
  ],
  templateUrl: 'search_dropdown.html',
  styleUrls: ['search_dropdown.css'],
  preserveWhitespace: true,
)
class SelectDropdown implements OnInit{
  final DropdownService dropdownService;
  static List<Language> _languagesList = [];
  ExampleSelectionOptions languageListOptions;
  String selectedValue = '';
  String selectedKey= '';

  SelectDropdown(this.dropdownService) {

  }

  Future<void> getAll() async {
    try {
      _languagesList = await dropdownService.getAll();
      languageListOptions =
          ExampleSelectionOptions(_languagesList);
    } catch (e) {
      var errorMessage = e.toString();
    }
  }

  void ngOnInit() => getAll();

  x() {
    if(singleSelectModel.isNotEmpty) {
      print(singleSelectModel.selectedValues.first.code);
      selectedKey = singleSelectModel.selectedValues.first.code;
      selectedValue = singleSelectModel.selectedValues.first.label;
    } else {
      selectedKey = '';
      selectedValue = '';
    }
  }

  static List<OptionGroup<Language>> _languagesGroups = [];

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

  bool useFactoryRenderer = false;
  bool useItemRenderer = false;
  bool useLabelFactory = false;
  bool useOptionGroup = false;
  bool withHeaderAndFooter = false;
  bool popupMatchInputWidth = true;
  bool visible = false;
  bool deselectOnActivate = false;
  String deselectLabel = 'Please Select';

  /// Languages to choose from.


  ExampleSelectionOptions languageGroupedOptions =
  ExampleSelectionOptions.withOptionGroups(_languagesGroups);

  StringSelectionOptions<Language> get languageOptions =>
      useOptionGroup ? languageGroupedOptions : languageListOptions;

  /// Single Selection Model
  final SelectionModel<Language> singleSelectModel =
  SelectionModel.single(selected: null);

  /// Label for the button for single selection.
  String get singleSelectLanguageLabel =>
      singleSelectModel.selectedValues.isNotEmpty
          ? itemRenderer(singleSelectModel.selectedValues.first)
          : 'Please Select';

  /// Multi Selection Model
  final SelectionModel<Language> multiSelectModel =
  SelectionModel<Language>.multi();

  final SelectionModel<int> widthSelection = SelectionModel<int>.multi();
  final SelectionOptions<int> widthOptions =
  SelectionOptions<int>.fromList([0, 1, 2, 3, 4, 5]);
  String get widthButtonText => widthSelection.selectedValues.isNotEmpty
      ? widthSelection.selectedValues.first.toString()
      : '0';

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

  int get width => widthSelection.selectedValues.isNotEmpty
      ? widthSelection.selectedValues.first
      : null;

  List<RelativePosition> get preferredPositions {
    switch (popupPositionButtonText) {
      case 'Above':
        return _popupPositionsAboveInput;
      case 'Below':
        return _popupPositionsBelowInput;
    }
    return RelativePosition.overlapAlignments;
  }
  Language selectionValue;
  String get slide => slideSelection.selectedValues.isNotEmpty &&
      slideSelection.selectedValues.first != 'Default'
      ? slideSelection.selectedValues.first
      : null;

  String get singleSelectedLanguage =>
      singleSelectModel.selectedValues.isNotEmpty
          ? singleSelectModel.selectedValues.first.uiDisplayName
          : null;

  /// Currently selected language for the multi selection model
  String get multiSelectedLanguages =>
      multiSelectModel.selectedValues.map((l) => l.uiDisplayName).join(',');

  ItemRenderer<Language> get itemRenderer =>
      useItemRenderer ? _itemRenderer : _displayNameRenderer;

  FactoryRenderer get factoryRenderer =>
      useFactoryRenderer ? (_) => demo.ExampleRendererComponentNgFactory : null;

  FactoryRenderer get labelFactory => useLabelFactory
      ? (_) => demo.ExampleLabelRendererComponentNgFactory
      : null;

  /// Label for the button for multi selection.
  String get multiSelectLanguageLabel {
    var selectedValues = multiSelectModel.selectedValues;
    if (selectedValues.isEmpty) {
      return "Select Languages";
    } else if (selectedValues.length == 1) {
      return itemRenderer(selectedValues.first);
    } else {
      return "${itemRenderer(selectedValues.first)} + ${selectedValues.length - 1} more";
    }
  }

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
}

class Language implements HasUIDisplayName {
  final String code;
  final String label;
  const Language(this.code, this.label);
  @override
  String get uiDisplayName => label;

  @override
  String toString() => uiDisplayName;

  factory Language.fromJson(Map<String, dynamic> dataList) =>
      Language(dataList['id'], dataList['name']);

  Map toJson() => {'id': code, 'name': label};
}

@Component(
  selector: 'example-renderer',
  template: r'''
        <material-icon icon="language" baseline></material-icon>{{displayName}}
    ''',
  styles: ['material-icon { margin-right: 8px; }'],
  directives: [MaterialIconComponent],
)
class ExampleRendererComponent implements RendersValue<Language> {
  String displayName = '';

  @override
  set value(Language newValue) {
    displayName = newValue.uiDisplayName;
  }
}

@Component(
  selector: 'example-label-renderer',
  template: r'''
        <material-icon icon="language" baseline></material-icon>{{displayName}}
    ''',
  styles: [
    ':host { margin-left: 16px}'
        'material-icon { margin-right: 8px}',
  ],
  directives: [MaterialIconComponent],
)
class ExampleLabelRendererComponent implements RendersValue<OptionGroup> {
  String displayName = '';

  @override
  set value(OptionGroup newValue) {
    displayName = newValue.uiDisplayName ?? 'Languages';
  }
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

