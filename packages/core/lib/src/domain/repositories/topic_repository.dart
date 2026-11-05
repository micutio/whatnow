import '../entities/topic.dart';

/// Hold all topics of the application.
abstract interface class TopicRepository {
  TopicRepository addTopic(Topic t);
  TopicRepository removeTopic(Topic t);

  Iterable<Topic> get allTopics;

  /// Retrieves a topic by its tag.
  Topic? getTopic(String topicTag);
}
