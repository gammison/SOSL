int main() {
    int a;
    int i;
    a = 10;

    for (i=0; i<5; i= i+1){
        if (a == 30) {
            break;
        }
        a = a + 10;
    }

    print(a);
    
	return 0;
}
