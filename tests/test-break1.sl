int main() {
    int a = 10;

    for (int i=0; i<5; i++){
        if (a == 30) {
            break;
        }
        a = a + 10;
    }

    print(30);
    
	return 0;
}