# Sử dụng JDK 21 cho giai đoạn build
FROM maven:3.9-amazoncorretto-21 AS build

# Thiết lập thư mục làm việc
WORKDIR /app

# Sao chép pom.xml và tải trước các dependency
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Sao chép mã nguồn và build ứng dụng
COPY src ./src
RUN mvn package -DskipTests

# Sử dụng JRE 21 cho giai đoạn runtime
FROM amazoncorretto:21-alpine-jre

# Thiết lập thư mục làm việc
WORKDIR /app

# Tạo thư mục uploads/images để lưu trữ ảnh
RUN mkdir -p /app/uploads/images

# Đặt biến môi trường
ENV SPRING_PROFILES_ACTIVE=prod

# Sao chép JAR từ giai đoạn build
COPY --from=build /app/target/*.jar app.jar

# Expose cổng mà Spring Boot sẽ chạy
EXPOSE 8080

# Thiết lập điểm vào
ENTRYPOINT ["java", "-jar", "app.jar"] 