int main()
{
    set:{int}: a;
    set:{int}: b;
    set:{int}: c; 
    int result;
    
    a = :{1,2,3}:;
    b = :{4,6,6}:;

    c = a :u b;
    
    result = (c :i 1) + 10000;
    print(result);
	return 0;
}
