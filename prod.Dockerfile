FROM alpine:latest AS base

RUN apk add git openjdk17

RUN git clone https://github.com/dmdev2020/spring-starter.git
#а не RUN cd spring-starter
WORKDIR spring-starter
# bootJar - таска gradle по сборке jar. Собранные jar кладутся в build/libs
RUN git checkout lesson-125 && ./gradlew bootJar

FROM alpine:latest AS result

RUN apk add openjdk17

WORKDIR /app

COPY --from=base /spring-starter/build/libs/spring-starter-*.jar ./service.jar
COPY application-dev.yaml .

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "service.jar"]
# Нужно переопределить url для БД в jar. Можно это сделать с помощью enviroment variables,
# а можно с помощью доп. конфигурационного файла, как сделано тут
#application.yml уже лежит в classpath, а для указания доп файла, который мы положили просто в корень проекта используем 'file'
CMD ["--spring.config.location=classpath:/application.yml,file:application-dev.yaml"]