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

  // Single Search Variables
  String selectionValue;
  String selectionOption;
  String languageButtonLabel = 'Select Language';
  List<String> get languagesList => stringList;

  @override
  void ngOnInit() {
    // TODO: implement ngOnInit
  }


  static List<String> stringList = <String>[
    "US English",
    "Danish",
    "Esperanto",
    "German",
    "Galician",
    "Czech",
    "Chinese",
    "Bengali",
    "Arabic"
  ];


  static ItemRenderer _displayNameRenderer =
      (item) => (item as String);


  /// Languages to choose from.
  ExampleSelectionOptions languageListOptions =
  ExampleSelectionOptions(stringList);


  StringSelectionOptions<String> get languageOptions =>
       languageListOptions;

  /// Single Selection Model
  final SelectionModel<String> singleSelectModel =
  SelectionModel.single(selected: stringList[1]);

  /// Label for the button for single selection.
  String get singleSelectLanguageLabel =>
      singleSelectModel.selectedValues.isNotEmpty
          ? itemRenderer(singleSelectModel.selectedValues.first)
          : 'Select Language';


  /*
   * Pop up position of list.
   */
  final SelectionModel<String> popupPositionSelection =
  SelectionModel<String>.multi();
  final StringSelectionOptions popupPositionOptions =
  StringSelectionOptions<String>(['Auto', 'Above', 'Below']);
  String get popupPositionButtonText =>
      popupPositionSelection.selectedValues.isNotEmpty
          ? popupPositionSelection.selectedValues.first
          : 'Auto';

  String get singleSelectedLanguage =>
      singleSelectModel.selectedValues.isNotEmpty
          ? singleSelectModel.selectedValues.first
          : null;


  ItemRenderer<String> get itemRenderer => _displayNameRenderer;



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

}



/// If the option does not support toString() that shows the label, the
/// toFilterableString parameter must be passed to StringSelectionOptions.
class ExampleSelectionOptions extends StringSelectionOptions<String>
    implements Selectable<String> {
  ExampleSelectionOptions(List<String> options)
      : super(options,
      toFilterableString: (String option) => option.toString());
  ExampleSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups)
      : super.withOptionGroups(optionGroups,
      toFilterableString: (String option) => option.toString());
  @override
  SelectableOption getSelectable(String item) =>
      item is String && item.contains('en')
          ? SelectableOption.Selectable
          : SelectableOption.Selectable;
}
