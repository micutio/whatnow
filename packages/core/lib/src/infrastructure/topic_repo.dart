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

  // TODO: Decide whether to return `Iterable<Topic>` instead.
  @override
  Iterable<Topic> allTopics() {
    return _topics.values;
  }

  @override
  Topic? getTopic(String topicTag) => _topics[topicTag];

  @override
  TopicRepository removeTopic(Topic t) {
    final nextTopics = Map<String, Topic>.of(_topics)..remove(t.id);
    return CoreTopicRepository(topics: nextTopics);
  }
}
