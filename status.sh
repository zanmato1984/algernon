#!/bin/bash

watch -n 1 "docker-compose ps && docker-compose -f docker-compose-learner.yaml ps"
