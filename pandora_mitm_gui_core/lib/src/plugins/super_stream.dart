import 'package:pandora_mitm/plugins.dart' as pmplg;
import 'package:pandora_mitm_gui_core/src/plugins/mixins/annotation_stream.dart';
import 'package:pandora_mitm_gui_core/src/plugins/mixins/object_stream.dart';

class SuperStreamPlugin = pmplg.StreamPlugin
    with AnnotationStreamMixin, ObjectStreamMixin;
