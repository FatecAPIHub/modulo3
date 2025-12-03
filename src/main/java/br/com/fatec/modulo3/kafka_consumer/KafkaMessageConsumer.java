package br.com.fatec.modulo3.kafka_consumer;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class KafkaMessageConsumer {

    @KafkaListener(topics = "${kafka.topic.name}", groupId = "${kafka.consumer.group-id}")
    public void consumeMessage(String message) {
        System.out.println("A mensagem chegou: " + message);
    }
}