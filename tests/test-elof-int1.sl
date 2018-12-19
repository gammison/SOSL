int main()
{
    set:{int}: a;
    int result;

    a = :{1,2,3}:;
    result = 100;

    if (a :i 3){
        result = result + 100;
    }

    print(result);

	return 0;
}
