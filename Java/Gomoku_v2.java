package nathaniel.gomoku;
import java.util.Scanner;
import java.util.Random;

public class Gomoku
{
    static Scanner input = new Scanner(System.in);
    final static int SIZE=15;
    static char[][] board =  new char[SIZE][SIZE];
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
        for (int i=0; i<SIZE; i++)
            for (int j=0; j<SIZE; j++)
                board[i][j]='.';
        String player="Megamind";
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
        char[] arr = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O'}; //,'P','Q','R','S','T','U','V','W','X','Y','Z'};
        int i=x-1, j;
        for (j=0; j<SIZE; j++)
            if (ch==arr[j])
                break;
        if (i>=0 && i<SIZE && j>=0 && j<SIZE)
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
    }
    static boolean openSquare(int i, int j)
    {
        return (board[i][j]=='.');
    }
    static void place(int i, int j, char d)
    {
        board[i][j]=d;
        checkWin(i,j,d);
    }
    static void display()
    {
        System.out.println("    A  B  C  D  E  F  G  H  I  J  K  L  M  N  O");
        for (int i=0; i<SIZE; i++)
        {
            System.out.printf("%2d  ",i+1);
            for (int j=0; j<SIZE; j++)
                System.out.print(board[i][j]+"  ");
            System.out.printf("\n");
        }
    }
    static void checkWin(int i, int j, char d)
    {
        if (i>0 && i<14 && j>0 && j<14)
            if (board[i-1][j-1]==d || board[i-1][j]==d || board[i-1][j+1]==d || 
                board[i][j-1]==d ||                   board[i][j+1]==d ||     
                board[i+1][j-1]==d || board[i+1][j]==d || board[i+1][j+1]==d)
            {
                display();
                System.out.printf("\n\nTWO IN A ROW\n\n");
                gameWon=true;
            }
        
        // Winning Move on Edge //
        if (i==0 && j>0 && j<14)
            if (board[i][j-1]==d ||                   board[i][j+1]==d ||
                board[i+1][j-1]==d || board[i+1][j]==d || board[i+1][j+1]==d)
            {
                display();
                System.out.print("\n\nTop\n\n");
                gameWon=true;
            }
        if (i>0 && i<14 && j==0)
            if (board[i-1][j]==d || board[i-1][j+1]==d ||
                                      board[i][j+1]==d ||
                board[i+1][j]==d || board[i+1][j+1]==d)
            {
                display();
                System.out.print("\n\nLeft\n\n");
                gameWon=true;
            }
        if (i>0 && i<14 && j==14)
            if (board[i-1][j-1]==d || board[i-1][j]==d ||
                board[i][j-1]==d || 
                board[i+1][j-1]==d || board[i+1][j]==d)
            {
                display();
                System.out.print("\n\nRight\n\n");
                gameWon=true;
            }
        if (i==14 && j>0 && j<14)
            if (board[i-1][j-1]==d || board[i-1][j]==d || board[i-1][j+1]==d ||
                board[i][j-1]==d ||                   board[i][j+1]==d)
            {
                display();
                System.out.print("\n\nBottom\n\n");
                gameWon=true;
            }
        
        
        // Winning Move Placed on Corner //
        if (i==0 && j==0)
            if (board[i][j+1]==d || board[i+1][j+1]==d || board[i+1][j]==d)
            {
                display();
                System.out.print("\n\nCorner 1\n\n");
                gameWon=true;
            }
        if (i==0 && j==14)
            if (board[i][j-1]==d || board[i+1][j-1]==d || board[i+1][j]==d)
            {
                display();
                System.out.print("\n\nCorner 2\n\n");
                gameWon=true;
            }
        if (i==14 && j==0)
            if (board[i-1][j]==d || board[i-1][j+1]==d || board[i][j+1]==d)
            {
                display();
                System.out.print("\n\nCorner 3\n\n");
                gameWon=true;
            }
        if (i==14 && j==14)
            if (board[i][j-1]==d || board[i-1][j-1]==d || board[i-1][j]==d)
            {
                display();
                System.out.print("\n\nCorner 4\n\n");
                gameWon=true;
            }
        
        
        // Scan adjacent 8 (edge placement does 5, corner does 3)
        // Continue in direction until opposite player is found or five-in-a-row
        
        //System.out.printf("%s Won!\n", "Gru");
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
} 