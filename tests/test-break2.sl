int main() {
    string stmt;
    int i;
    stmt  = "not Modified!";

    for (i=0; i<5; i=i+1){
        break;
        stmt = "Modified";
    }

    prints(stmt);
    
	return 0;
}
