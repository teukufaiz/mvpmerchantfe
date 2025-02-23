import connect
import register

print("## Selamat datang di XXYY Apps ###")

def display_menu():
    print("1. Register")
    print("2. Login")
    print("3. Exit")
    pilihan = input("Silahkan anda pilih menu yang sesuai: ")
    print("#"*100)
    return int(pilihan)

if connect.mydb:
    # print("Database berhasil connect")
    start = True
    while start == True:
        menu = display_menu()
        if menu == 1:
            # print("ini register")
            register.register_main()
        elif menu == 2:
            print("ini login")
        elif menu == 3:
            print("Anda berhasil keluar dari aplikasi")
            break
    
else:
    print("Database tidak connect")



