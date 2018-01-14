int main() {
    static int x[] = {1, 5, 6, 9};
    int i;
    int sum;
    for (i = 0; i < 4; i++) {
        sum += x[i];
    }

    return sum;
}
