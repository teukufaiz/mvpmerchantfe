## Validasi UserID
def validasi_userid(userid):
    if len(userid) < 6 or len(userid) > 20:
        print("UserID harus 6-20 karakter")
        print("="*100)
    
    huruf = False
    angka = False

    for karakter in userid:
        if karakter.isalpha():
            huruf = True
        elif karakter.isdigit():
            angka = True
    if huruf == False and angka == False:
        print("UserID harus berisi huruf atau angka")
        print("="*100)
    
    # for user in users:
    #     if user["UserId"] == userid:
    #         print("UserID sudah terdaftar")
    #         print("="*100)
    
    return True

#validasi email
def validasi_email(email):
    if email.count('@') == 1:
        email_rest = email.split("@")

        if '.' not in email_rest[1]:
            print("Email Tidak Valid, Format Email Salah")
        else: 
            extension = email_rest[1]
            
            hosting = extension.split(".")[0]
            ext = extension.split(".")[1]
            if len(ext) > 5:
                raise Exception("Email Tidak Valid, Format Ekstensi yg anda masukkan Salah")
            
            # check_username(email_rest[0])
            # check_hosting(hosting[1])
            if(check_username(email_rest[0]) == True and check_hosting(hosting[1]) == True):
                return True
    else: 
        print("Email Tidak Valid, Format Email Salah")
    # print(temp)
    # print(hosting[1])

def check_username(str):
    symbol= ["#", "$", "%", "&", "*", "(", ")"
             ";", ":", "/", "=", "+", "-"]
    for i in symbol:
        if str.find(i) != -1:
            print("Email Tidak Valid, Format Username yg anda masukkan salah")
            break
        # else:
        #     print("Yey")
        #     break
    if str[0] == "_" and str[0] == ".":
        print("Email Tidak Valid, Format Username yg anda masukkan salah")
    else:
        return True

def check_hosting(str):
    check_str = list(str)
    if check_str.count(".") > 1:
        print("Email Tidak Valid, Format Hosting yg anda masukkan Salah")
    else:
        return True
    
def validasi_password(password):
    count_digit = 0
    count_alpha = 0
    count_special = 0
    count_upper = 0
    count_lower = 0

    special_character = ["@","#", "$", "%", "&", "*", "-", "_", "/", "!", "|"]
    if len(password) < 8:
        print("Password harus terdapat 8 digit")
        print("="*100)
    else: 
        for karakter in password:
            if karakter.isdigit():
                count_digit += 1
            elif karakter.isalpha():
                count_alpha += 1
                if karakter.isupper():
                    count_upper += 1
                else:
                    count_lower += 1
            else:
                for i in special_character:
                    if karakter == i:
                        count_special += 1
        if count_digit == 0:
            print("Password harus terdapat kombinasi dengan angka")
            print("="*100)
        elif count_alpha == 0:
            print("Password harus terdapat kombinasi dengan alphabet")
            print("="*100)
        elif count_upper == 0:
            print("Password harus terdapat kombinasi huruf besar")
            print("="*100)
        elif count_lower == 0:
            print("Password harus terdapat kombinasi huruf kecil")
            print("="*100)
        elif count_special == 0:
            print("Password harus terdapat kombinasi dengan special character")
            print("="*100)
        else:
            return True
    
def temp_save(user_dictionary):
    var_conf = input("Apakah anda yakin untuk menyimpan data? (Y/N): ")
    if var_conf.islower():
        var_conf = var_conf.isupper()
    if var_conf == "Y":
        print(len(user_dictionary))
        print("Data anda berhasil tersimpan")
        print("="*100)
    elif var_conf == "N":
        print("Data anda tidak tersimpan")
        print("="*100)
    else:
        print("Masukkan input yang sesuai!")
        print("="*100)


def register_main():

    passIsConfirmed = False
    userIDConfirmed = False
    emailConfirmed = False
    nameConfirmed = False
    genderConfirmed = False
    ageConfirmed = False
    jobConfirmed = False
    cityConfirmed = False
    addressConfirmed = False
    geoConfirmed = False
    numConfirmed = False

    while userIDConfirmed == False:
        userid = input("Masukkan USER ID untuk akun anda: ")
        validation_user = validasi_userid(userid)
        if validation_user == True:
            userIDConfirmed == True
            # print("UserID Valid")
            break

    while emailConfirmed == False:
        email = input("Masukkan Email anda: ")
        validation_email = validasi_email(email)
        if validation_email == True:
            break
    
    while passIsConfirmed == False:
        password = input("Masukkan password anda: ")
        confirmPassword = input("Masukkan password anda kembali: ")

        if password == confirmPassword:
            validation_password = validasi_password(password)
            if validation_password == True:
                # print("Password sudah sesuai dengan ketentuan")
                break
        else:
            print("Password anda tidak terkonfirmasi, silahkan ulangi kembali prosesnya")
            print("="*100)

    while nameConfirmed == False:
        name = input("Masukkan nama anda: ")
        if name != '' and all(n.isalpha() or n.isspace() for n in name):
            break
        else:
            print("Nama harus menggunakan alphabet")
            print("="*100)
    
    while genderConfirmed == False:
        print("1. Pria")
        print("2. Wanita")
        option = int(input("Masukkan nomor yang sesuai dengan gender anda: "))
        if option == 1: 
            gender = "Pria"
            break
        elif option == 2:
            gender = "Wanita"
            break
        else:
            print("Masukkan nomor yang sesuai")
            print("="*100)
    
    while ageConfirmed == False:
        age = int(input("Masukkan umur anda: "))
        if age <= 17 and age >= 80:
            print("Umur tidak boleh lebih dari 80 dan kurang dari 17")
            print("="*100)
        else:
            break

    while jobConfirmed == False:
        job = input("Masukkan pekerjaan anda: ")
        if job.isalpha():
            break
        else:
            print("Pekerjaan yang anda masukkan harus berupa abjad. ")
            print("="*100)
    
    while cityConfirmed == False:
        city = input("Masukkan kota tinggal anda: ")
        if city.isalpha():
            break
        else:
            print("Kota yang anda masukkan harus berupa abjad. ")
            print("="*100)

    while addressConfirmed == False:
        rt = input("Masukkan RT anda: ")
        rw = input("Masukkan RW anda: ")
        zipcode = input("Masukkan Kode Pos anda: ")

        if rt.isdigit() and rw.isdigit(): 
            break
        else:
            print("RT dan RW harus berbentuk angka")
            print("="*100)

        if zipcode.isdigit() and len(zipcode) < 5:
            break
        else:
            print("Kodepos anda tidak sesuai.")

    while geoConfirmed == False:
        lat = input("Masukkan nilai latitude dari lokasi anda: ")
        long = input("Masukkan nilai longitude dari lokasi anda: ")

        # print(lat[0])
        if lat.isalpha() and long.isalpha():
            print("Latitude dan Longitude harus berbentuk angka")
            print("="*10)
        else:
            if lat[0] == "-" and long[0] == "-":
                lat = -(float(lat.split('-')[1]))
                long = -(float(long.split('-')[1]))

                # if lat < 0:
                #     print(True)

                break
            elif lat[0] == "-":
                lat = -(float(lat.split('-')[1]))

                if long.isdigit:
                    long = float(long)
                break

            elif long[0] == "-":
                long = -(float(long.split('-')[1]))

                if lat.isdigit():
                    lat = float(lat)
                break

            else:
                if lat.isdigit() and long.isdigit():
                    long = float(long)
                    lat = float(lat)
                    break

                else:
                    print("Latitude dan Longitude harus berbentuk angka")
                    print("="*10)
            # print(lat)
            # print(long)
    while numConfirmed == False:
        num = input("Masukkan nomor handphone anda: ")
        if num.isdigit():
            if len(num) >= 11 and len(num) <= 13:
                break
            else:
                print("Nomor handphone anda kurang dari 11 karakter atau lebih dari 13 karakter")
                print("="*10)
        else:
            print("Nomor handphone harus berupa angka")
            print("="*10)

    user = {
        "user-id": userid,
        "name": name,
        "age": age,
        "gender": gender,
        "job": job,
        "city": city,
        "rt": rt,
        "rw": rw,
        "latitude": lat,
        "longitude": long, 
        "num": num
    }    

    temp_save(user)

            