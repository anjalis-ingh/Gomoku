import java.util.Scanner;
import java.util.Random;

class Gomoku
{
    static Scanner input = new Scanner(System.in);
    static char[][] board =  new char[15][15];
    static char c;
    static boolean gameWon=false;
    
    public static void main(String[] args)
    {
        while (true)
        {
            startGame();
            while (!gameWon)
                gameRound();
        }
    }
    
    static void startGame()
    {
        gameWon=false;
        for (int i=0; i<15; i++)
            for (int j=0; j<15; j++)
                board[i][j]='.';
        String player="";
        while (!player.equals("Black") && !player.equals("White"))
        {
            System.out.print("Choose Black or White: ");
            player = input.nextLine();
        }
        if (player.equals("Black")) c='X';
        else c='O';
    }
    
    static void gameRound()
    {
        if (c == 'X')
        {
            display();
            boolean okMove=false;
            while (!okMove)
            {
                System.out.print("MOVE: ");
                String userMove = input.nextLine();
                okMove = validateGeneral(userMove);
            }
            if (!gameWon)
                computerMove();
        }
        else
        {
            computerMove();
            display();
            if (!gameWon)
            {
                boolean okMove=false;
                while (!okMove)
                {
                    System.out.print("MOVE: ");
                    String userMove = input.nextLine();
                    okMove = validateGeneral(userMove);
                }            
            }
        }
    }
    
    static boolean validateGeneral(String s)
    {
        if (s.length()==2 || s.length()==3)
        {
            if (Character.isAlphabetic(s.charAt(0)) && Character.isDigit(s.charAt(1)))
            {
                if (s.length()==3 && !Character.isDigit(s.charAt(2)))
                {
                    System.out.println("Cannot place: INVALID FORMAT!");
                    return false;
                }

                char d = s.charAt(0);
                int i = Integer.parseInt(s.substring(1));
                return validateMove(d,i);
            }
        }
        System.out.println("Cannot place: IMPROPER LOCATION!");
        return false;
    }
    
    static boolean validateMove(char ch, int x)
    {
        char[] arr = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'};
        int i=x-1, j;
        for (j=0; j<15; j++)
            if (ch==arr[j])
                break;
        if (i>=0 && i<15 && j>=0 && j<15)
        {
            if (openSquare(i,j))
            {
                place(i,j,c);
                return true;
            }
            else System.out.println("Cannot place: ALREADY FILLED!");
        }
        else System.out.println("Cannot place: OUT OF BOUNDS!");
        return false;
    }
    
    static void computerMove()
    {
        char comp;
        int r1=0, r2=0;
        if (c=='X') comp='O';
        else comp='X';

        boolean okToPlace=false;
        while (!okToPlace)
        {
            Random r = new Random();
            r1 = r.nextInt(15); // exclusive, get [0,14]
            r2 = r.nextInt(15);
            okToPlace=openSquare(r1,r2);
        }
        place(r1, r2, comp);
        System.out.print("COMPUTER MOVE: ");
        char[] arr = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'};
        System.out.println(arr[r2]+""+(r1+1));
    }
    
    static boolean openSquare(int i, int j)
    {
        return (board[i][j]=='.');
    }
    
    static void place(int i, int j, char d)
    {
        board[i][j]=d;
        checkWin(d);
    }
    
    static void display()
    {
        System.out.println("    A  B  C  D  E  F  G  H  I  J  K  L  M  N  O");
        for (int i=0; i<15; i++)
        {
            System.out.printf("%2d  ",i+1);
            for (int j=0; j<15; j++)
                System.out.print(board[i][j]+"  ");
            System.out.printf("\n");
        }
    }
    
    static void checkWin(char d)
    {   
        for (int i=0; i<15; i++)
            for (int j=0; j<15; j++)
            {
                if (!gameWon)
                    scan(j>10, i,0, j,1, d); // MOVE RIGHT CHECK (j>10 || board[i][j+n] != d)
                if (!gameWon)
                    scan(j<4, i,0, j,-1, d); // MOVE LEFT CHECK (j<4 || board[i][j-n] != d)
                if (!gameWon)
                    scan(i<4, i,-1, j,0, d); // MOVE UP CHECK (i<4) || board[i-n][j] != d)
                if (!gameWon)
                    scan(i>10, i,1, j,0, d); // MOVE DOWN CHECK i>10 || board[i+n][j] != d)
                if (!gameWon)
                    scan((i<4 || j<4), i,-1, j,-1, d); // UP LEFT DIAGONAL
                if (!gameWon)
                    scan((i<4 || j>10), i,-1, j,1, d); // UP RIGHT DIAGONAL
                if (!gameWon)
                    scan((i>10 || j>10), i,1, j,1, d); // DOWN RIGHT DIAGONAL
                if (!gameWon)
                    scan((i>10 || j<4), i,1, j,-1, d); // DOWN LEFT DIAGONAL
            }
        if (gameWon)
        {
            System.out.print("Play again? (Y/N): ");
            if (input.nextLine().equals("N"))
            {
                System.out.println("Thanks for playing!");
                System.exit(0);
            }
        }
    }
    
    static void scan(boolean comp, int i, int ii, int j, int jj, char d)
    {
        boolean matching = true;
        for (int n=0; n<5; n++)
            if (comp || board[i+ii*n][j+jj*n] != d) 
                matching=false;

        if (matching)
        {
            display();
            String player = (d==c ? "YOU" : "COMPUTER");
            String color = (d=='X' ? "BLACK" : "WHITE");
            String plural = (d==c ? "" : "S");
            System.out.printf("\n%s (%s) WIN%s!!!\n\n", player, color, plural);
            gameWon=true;
        }
    }
}
