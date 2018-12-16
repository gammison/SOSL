int main()
{
    set:{int}: a;
    int result;

    a = {1,2,3};
    result = 100;

    if (3 :i a){
        result = result + 100;
    }
    
    print(result);
	return 0;
}
