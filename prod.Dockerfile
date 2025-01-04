FROM alpine:latest

RUN apk add git openjdk17

RUN git clone https://github.com/dmdev2020/spring-starter.git
#а не RUN cd spring-starter
WORKDIR spring-starter
RUN git checkout lesson-125
# bootJar - таска gradle по сборке jar. Собранные jar кладутся в build/libs. Перекопируем этот jar в корень для удобства
RUN ./gradlew bootJar
RUN cp build/libs/spring-starter-*.jar ./service.jar

COPY application-dev.yaml .

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "service.jar"]
# Нужно переопределить url для БД в jar. Можно это сделать с помощью enviroment variables,
# а можно с помощью доп. конфигурационного файла, как сделано тут
#application.yml уже лежит в classpath, а для указания доп файла, который мы положили просто в корень проекта используем 'file'
CMD ["--spring.config.location=classpath:/application.yml,file:application-dev.yaml"]