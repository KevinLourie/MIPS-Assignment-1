void itoa(int n, char s[]);
char* reverse_string(char *str, int len);

int main() {
	static char number[100];
	itoa(73, number);
   return 0;
}

void itoa(int n, char s[]) {
    int i = 0;
    int sign = n; /* record sign */

    if (sign < 0) {
        n = -n;          /* make n positive */
    }

    do {       /* generate digits in reverse order */
        s[i++] = n % 10 + '0';   /* get next digit */
    } while ((n /= 10) > 0);     /* delete it */

    if (sign < 0) {
        s[i++] = '-';
    }

    s[i] = '\0';

    reverse_string(s, i);
}

char* reverse_string(char *str, int len) {
    int i;
    int k = len - 1;

    for(i = 0; i < len/2; i++) {
        char temp = str[k];
        str[k] = str[i];
        str[i] = temp;
        k--;
    }
}
