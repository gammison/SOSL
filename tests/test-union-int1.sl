int main()
{
    set:{int}: a;
    set:{int}: b;
    
    a = {1,2,3};
    b = {4,5,6};

    c = a :u b;
    
    prints(c);
	return 0;
}