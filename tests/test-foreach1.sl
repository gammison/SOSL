int main()
{
    set:{int}: a;
    int sum;

    a = {1,2,3};
    sum = 0;

    foreach (int k in a) {
        sum = sum + k;
    }
    
    print(sum);
	return 0;
}