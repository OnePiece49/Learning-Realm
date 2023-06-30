# Learning-Realm

Install Realm
```php
pod 'RealmSwift', '~>10'
```

Find Fild Realm
```php
po Realm.Configuration.defaultConfiguration.fileURL
```

## I. QuickStart

Near the top of any Swift file that uses Realm, add the following import statement:
```php
import RealmSwift
```

## 1.0 Kiểu dữ liệu List trong Realm
Trước đây, `List` class chỉ có thể store colleciton of realm object. Nhưng các phiên bảo sau này, `List` có thể chứa object, value types, optionals,... 


## 1.1 Model Data Swfit
- Object Types & Schema:
Một Readlm Model như là 1 đối tượng chứa ra nhiều field-value, các kiểu dữ liệu được support trong Realm sẽ được viết ở mục **1.3**

**Readlm Objects chỉ đơn giản là các Classes trong Swfit hoặc Objective-C**, nhưng Readlm cũng cấp thêm các feature như [live queries](https://www.mongodb.com/docs/realm/sdk/swift/realm-database/#std-label-ios-live-queries). The Swift SDK memory maps Realm objects directly to native Swift or Objective-C objects, which means there's no need to use a special data access library, such as an ORM. Instead, **you can work with Realm objects as you would any other class instance**.

Mọi Readlm Object cần comform **Object** type. Một Readlm Object là 1 class mà defint các properties và [relationships](https://www.mongodb.com/docs/realm/sdk/swift/model-data/#std-label-ios-client-relationships). Realm handles relationships thông qua việc sử dụng **reference properties** tới các Readlm Object khác. Vì vậy ta sẽ read hoặc write tới các properties này 1 cách trực tiếp. Realm hỗ trợ to-one, to-many, and inverse relationships.

- To-One RelationShip: Có nghĩa là 1 Object chỉ relates tới 1 Object khác
  
```php
class Person: Object {
    @Persisted var name: String = ""
    @Persisted var birthdate: Date = Date(timeIntervalSince1970: 1)
    // A person can have one dog
    @Persisted var dog: Dog?
}
class Dog: Object {
    @Persisted var name: String = ""
    @Persisted var age: Int = 0
    @Persisted var breed: String?
    // No backlink to person -- one-directional relationship
}
```

- To-Many relationShip: Có nghĩa là 1 đối tượng sẽ relate tới nhiều hơn 1 đối tượng khác.
  
```php
class Person: Object {
    @Persisted var name: String = ""
    @Persisted var birthdate: Date = Date(timeIntervalSince1970: 1)
    // A person can have many dogs
    @Persisted var dogs: List<Dog>
}
class Dog: Object {
    @Persisted var name: String = ""
    @Persisted var age: Int = 0
    @Persisted var breed: String?
    // No backlink to person -- one-directional relationship
}
```

- Inverse RelationShip: Ta nên biết rằng Relationship trong Realm là 1 chiều. Để 1 đối tượng khác link back tới đối tượng khác, ta phải explicit và sử dụng [LinkObject](https://www.mongodb.com/docs/realm-sdks/swift/latest/Structs/LinkingObjects.html).

```php
class User: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String = ""
    @Persisted var name: String = ""
    // A user can have many tasks.
    @Persisted var tasks: List<Task>
}
class Task: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String = ""
    @Persisted var text: String = ""
    // Backlink to the user. This is automatically updated whenever
    // this task is added to or removed from a user's task list.
    @Persisted(originProperty: "tasks") var assignee: LinkingObjects<User>
}
```

Bên cạnh đó, mọi Readlm Object là **live object,** điều này có nghĩa là nó sẽ tự động được update mỗi khi được thay đổi. Realm có thể phát ra một [notification event](https://www.mongodb.com/docs/realm/sdk/swift/react-to-changes/#std-label-ios-react-to-changes) bất cứ khi nào propertu bị thay đổi.

- Model Inheritance

Ta có thể subclass Realm Model để share behavior giữa những classes. Nhưng vẫn có 1 vài hạn chế mà **Realm không cho phép** như sau:
- Cast between polymorphic classes: subclass to subclass, subclass to parent, parent to subclass
- Query on multiple classes simultaneously: for example, "get all instances of parent class and subclass"
- Multi-class containers: List and Results with a mixture of parent and subclass

Chú ý: Từ version 10.10.0, chúng ta không thể mix `@Persisted` và `@objc dynamic` property trong cùng 1 class(Cái này không phải là trường hợp trùng tên nhé, mà là ko được phép tồn tại `@Persisted` và `@objc dynamic` trong cùng 1 class). Nếu cố tình khai báo cả 2, tất cả các `@objc dynamic property` sẽ bị ignore, dẫn đến dead app. Tuy nhiên, ta có thể mix 2 kiểu này giữa base class và subclass. For example, a base class could have a @Persisted var foo: Int property, and a subclass could have an @objc dynamic var bar = 0 property.

- Propeties:
Như đã nói, Realm Object Model là 1 collection của các properties. Khi khai báo model, chúng ta phải khai báo các propertíe, chúng ta cần **give Realm information about each property.**
-   Kiểu dữ liệu property, property đó là optional hay required
-   Liệu rằng Realm nên sotre hay ignore property.
-   Liệu rằng property đó là primary key hay không.

Khi ta tạo 1 group of object Realm, group đó được gọi là 1 **collection.** Collection là 1 đối tượng chứa 0 hoặc 1, hoặc nhiều instance của Realm Object. *Realm collections are homogenous: all objects in a collection are of the same type.*

Chúng ta có thể filter, sort collection bằng cách sử dung Realm'[query engine](https://www.mongodb.com/docs/realm/sdk/swift/crud/filter-data/#std-label-ios-client-query-engine).

## 1.2 Define a Realm Object Model
Khi ta define 1 Class, tên của class sẽ là tên của table trong Realm, và tên của propeties là tên của các column trong table.

- Declare Propeties
Khi ta khai báo 1 properties, ta có thể chỉ định rằng thuộc tính đó có được quản lý bởi Realm hay không. **Managed Properties** sẽ được lưu và update trong database. **Ignored propeties** sẽ không được lưu trong db. Chúng ta có thể mix managed and ignored properties trong cùng 1 class.

- Persisted Propeties Attributes:
Yuwf phiên bản 10.10.0: `@Persisted` được sử dụng để thay thế cho `@obj dynamic`, `RealmOptional` và `RealmPropety`. Khai báo propeties với từ khóa `@Persisted` khi ta muốn propeties đó được lưu vào trong database. Khi ta khai báo bất kì propeties nào với từ khoá `@Persisted` thì  các properties khác mà ko phải là `@Persisted` sẽ bị ignored.

- Objective-C Dynamic Property Attributes:
Với các version trước 10.10.0, ta có thể khai báo 1 biến với `@obj dynamic`. Ta có thể sử dụng 2 cách sau:
- Sử dụng `@obj dynamic` khi khai báo từng biến properties
- Sử dụng `@objcMembers` để khai báo class, sau đó khai báo các properties đó với `dynamic var.`
- Use let to declare LinkingObjects, List, RealmOptional and RealmProperty

```php
@objcMembers class MusicModel: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var name: String = ""
    dynamic var duration: Double = 0
    dynamic var artist: String = ""
}

class Project: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
}
```

- Specify a Primary Key
Chúng ta có thể chỉ định 1 property là **primary key** cho class. Primary key cho phép ta find, update, insert object 1 cách hiệu quả. Primary Key cũng có 1 vài limitations sau:
-   Chỉ được define 1 primary key trên 1 model
-   Primary key values phải là độc nhất trong tất cả các instance object của Realm. Nếu Primary Key nào có values bằng nhau, Realm sẽ throws an error.
-   Primary key values phải là immutable. Để thay đổi primary key value, ta phải xoá luôn object đó đi, và insert 1 object với primary key value mứoi.
-   [Embedded object](https://www.mongodb.com/docs/realm/sdk/swift/model-data/relationships/#std-label-ios-embedded-objects) ko thể defint 1 primary key.

Với after 10.10.0:

```php
class Project: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name = ""
}
```

Với before 10.10.0:

```php
class Project: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    // Return the name of the primary key property
    override static func primaryKey() -> String? {
        return "id"
    }
}
```

- Index a Propety: Chưa đọc, kiểu nó tạo subscript ý.


- ignore Property:
Ignored properties behave exactly like normal properties. They can't be used in queries and won't trigger Realm notifications. f you don't want to save a field in your model to its realm, leave the @Persisted notation off the property attribute.

Additionally, if you mix @Persisted and @objc dynamic property declarations within a class, the @objc dynamic properties will be ignored.

- Declare Enum Properties
Changed in version 10.10.0: Protocol is now `PersistableEnum` rather than `RealmEnum`. Trước version đó, Realm chỉ support Int và @objc enum

```php
// Define the enum with ver after 1.10
enum TaskStatusEnum: String, PersistableEnum {
    case notStarted
    case inProgress
    case complete
}
// To use the enum:
class Task: Object {
    @Persisted var name: String = ""
    @Persisted var owner: String?
    // Required enum property
    @Persisted var status = TaskStatusEnum.notStarted 
    // Optional enum property
    @Persisted var optionalTaskStatusEnumProperty: TaskStatusEnum? 
}
```

```php
// Define the enum with ver 10.10
@objc enum TaskStatusEnum: Int, RealmEnum {
    case notStarted = 1
    case inProgress = 2
    case complete = 3
}
// To use the enum:
class Task: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var owner: String?
    // Required enum property
    @objc dynamic var status = TaskStatusEnum.notStarted 
    // Optional enum property
    let optionalTaskStatusEnumProperty = RealmProperty<TaskStatusEnum?>() 
}
```

