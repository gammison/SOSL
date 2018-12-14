int main()
{ 
	int i; 
	i = 10; 
	{
		i = 15; 
		return i; 
	} 
	i = 10; 
}
