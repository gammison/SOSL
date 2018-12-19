int main()
{
    set:{int}: a;
    set:{int}: b;
    set:{int}: c; 
    
    a = :{1,2,3}:;
    b = :{4,5,6}:;

    c = a :u b;
    
    if (c :i ) {
        print(1);
    }

	return 0;
}
