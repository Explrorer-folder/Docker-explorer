# my first image
ARG alpine_version=latest
FROM alpine:${alpine_version} AS base
ARG builddno=1

WORKDIR /
WORKDIR app
WORKDIR build
# в этом моменте будет директория /app/build (/ + app + build)

RUN touch test2.txt && echo "Hello world!" >> test2.txt

# С помощью '\' и '&&' можно переносить команду, чтобы не писать её в одной длинной строке
# cd .. указывает директорию на одну выше. т.е. в /app будет выполняться
#  wget скачает архив. .gz - расширение архива для Linux
# tar разархивирует архив
# rm удалит скачанный архив т.к. он больше не нужен, вы его уже разархивировали
RUN cd ..  \
    && wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.31/bin/apache-tomcat-10.1.31.tar.gz \
    && tar -xvzf apache-tomcat-10.1.31.tar.gz \
    && rm apache-tomcat-10.1.31.tar.gz

# /app/build/idea-new
COPY .idea idea-new

COPY .idea/*.xml idea-new-xml/
COPY tomcat.tar.gz /app
ADD https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.31/bin/apache-tomcat-10.1.31.tar.gz tomcat-add.tar.gz

FROM alpine:latest
RUN apk add openjdk17
COPY --from=base /app/apache-tomcat-10.1.31 /app/apache-tomcat-10.1.31

#run - аргумент для самого скрипта catalina.sh
EXPOSE 8080
ENTRYPOINT ["/app/apache-tomcat-10.1.31/bin/catalina.sh"]
CMD ["run"]
# /app/apache-tomcat-10.1.31/bin/catalina.sh run
