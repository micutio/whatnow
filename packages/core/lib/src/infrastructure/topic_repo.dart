import 'dart:collection';

import '../domain/entities/topic.dart';
import '../domain/repositories/topic_repository.dart';

class CoreTopicRepository implements TopicRepository {
  CoreTopicRepository({Map<String, Topic>? topics})
    : _topics = Map<String, Topic>.unmodifiable(
        topics ?? {Topic.defaultId: Topic.unnamed},
      );

  final Map<String, Topic> _topics;

  @override
  TopicRepository addTopic(Topic t) {
    final nextTopics = Map<String, Topic>.of(_topics)..[t.id] = t;
    return CoreTopicRepository(topics: nextTopics);
  }

  @override
  UnmodifiableListView<Topic> get allTopics {
    return UnmodifiableListView(_topics.values.toList(growable: false));
  }

  @override
  Topic? getTopic(String topicTag) => _topics[topicTag];
}
