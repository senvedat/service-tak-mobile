import 'package:get_it/get_it.dart';
import 'package:service_tak_mobile/service/auth/login_service.dart';
import 'package:service_tak_mobile/service/hotel/hotel_guest_service.dart';
import 'package:service_tak_mobile/service/hotel/hotel_room_service.dart';
import 'package:service_tak_mobile/service/hotel/hotel_service.dart';
import 'package:service_tak_mobile/service/worker/worker_service.dart';

GetIt locator = GetIt.instance;

void initLocator() {
  locator.registerLazySingleton(() => LoginService());
  locator.registerLazySingleton(() => WorkerService());
  locator.registerLazySingleton(() => HotelService());
  locator.registerLazySingleton(() => HotelGuestService());
  locator.registerLazySingleton(() => HotelRoomService());
}
