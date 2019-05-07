import 'package:SelectWithSearchFreshStart/src/SimpleSingleSelectWithSearchComponent/simple_single_select_with_search_component.dart';
import 'package:angular/angular.dart';

import 'src/todo_list/todo_list_component.dart';
import 'src/login_static/login_static_component.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [TodoListComponent,SimpleSingleSelectWithSearch, LoginStatic],
)
class AppComponent {
  // Nothing here yet. All logic is in TodoListComponent.
}
