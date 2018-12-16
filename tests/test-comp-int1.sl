int main()
{
    set:{int}: a;
    set:{int}: b;
    
    a = {1,2,3};
    b = {3,4,5};

    c = a :c b;
    
    prints(c);
	return 0;
}