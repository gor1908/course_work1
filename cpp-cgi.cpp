#include <iostream>
#include <cstdlib>
#include <ctime>

using namespace std;

int main () {
   //generate random number
   srand((unsigned) time(0));
   cout << "Content-type:text/html\r\n\r\n";
   cout << "<html>\n";
   cout << "<head>\n";
   cout << "<title>Hello World - CGI Program</title>\n";
   cout << "</head>\n";
   cout << "<body>\n";
   cout << "<h2>Hello ! This is my first CGI program</h2>\n";
   cout << "<br> It can generate random numbers as: <u> " <<
	   rand()  << " </u>\n";
   cout << "</body>\n";
   cout << "</html>\n";
   
   return 0;
}
