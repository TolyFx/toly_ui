import 'package:tolyui_message/src/logic/notice/notification_mixin.dart';

import '../widget/theme/toly_message_style_theme.dart';
import 'message/message_mixin.dart';

MessageHandler $message = MessageHandler._();

class MessageHandler with ContextAttachable, MessageMixin, NotificationMixin {
  MessageHandler._();


}
