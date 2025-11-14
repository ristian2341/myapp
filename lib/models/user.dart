class User {

    // deklarasi variabel field
    final String? code;
    final String? username;
    final String? email;
    final String? nama_panggilan;
    final String? phone;
    final String? password;
    final String? longitudes;
    final String? latitude;
    final String? firebase;
    final int? developer;
    final int? supervisor;
    final String? login_at;
    final String? access_token;
    final String? verify_code;

    User(
        {
            this.code,
            this.username,
            this.email,
            this.nama_panggilan,
            this.phone,
            this.password,
            this.longitudes,
            this.latitude,
            this.firebase,
            this.developer,
            this.supervisor,
            this.login_at,
            this.access_token,
            this.verify_code,
        }
    );

    factory User.fromJson(Map<String,dynamic> json) {
        return User(
            code : (json['code'] ?? '') as String,
            username : (json['username'] ?? '') as String,
            email : (json['email'] ?? '') as String,
            nama_panggilan : (json['nama_panggilan'] ?? '') as String,
            phone : (json['phone'] ??  '') as String,
            password : (json['password'] ?? '') as String,
            longitudes : (json['longitudes'] ?? '') as String,
            latitude : (json['latitude'] ?? '') as String,
            firebase : (json['firebase'] ?? '') as String,
            developer : (json['developer'] ?? 0) as int,
            supervisor : (json['supervisor'] ?? 0) as int,
            login_at : (json['login_at'] ?? '') as String,
            access_token : (json['access_token'] ?? '') as String,
            verify_code : (json['verify_code'] ?? '') as String,
        );
    }

    Map<String,dynamic> toJson(){
        return {
            'code': code,
            'username': username,
            'email': email,
            'nama_panggilan': nama_panggilan,
            'phone': phone,
            'password': password,
            'longitudes': longitudes,
            'firebase': firebase,
            'developer': developer,
            'supervisor': supervisor,
            'login_at': login_at,
            'access_token' : access_token,
            'verify_code': verify_code
        };
    }
}