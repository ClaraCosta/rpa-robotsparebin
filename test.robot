*** Settings ***
Resource    producer.robot
Resource    consumer.robot
Resource    finisher.robot

*** Tasks ***
Test Full Workflow
    Producer Workflow
    Consumer Workflow
    Finisher Workflow
