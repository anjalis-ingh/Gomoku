package nathaniel.mnk;

import java.util.Scanner;
import java.util.concurrent.ThreadLocalRandom;

public class MNK
{
    final static int size=12;
    final static char[] a = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
    
    static char[][] board =  new char[size][size];
    
    public static void main(String[] args)
    {
        Scanner input = new Scanner(System.in);
        
        // INITIALIZE BOARD
        for (int i=0; i<size; i++)
            for (int j=0; j<size; j++)
                board[i][j]='.';

        System.out.print("Choose character: ");
        char c = input.nextLine().charAt(0);
        display();

        for (int r=0; r<5; r++)
        {
            System.out.print("MOVE: ");
            String move = input.nextLine();
            if (update(move,c))
            {

                //int r1 = ThreadLocalRandom.current().nextInt(0, size);
                //int r2 = ThreadLocalRandom.current().nextInt(0, size);
                boolean moved=false;
                for (int i=0; i<size; i++)
                {
                    if (moved) break;
                    for (int j=0; j<size; j++)
                        if (board[i][j]=='.')
                        {
                            if (c=='O') board[i][j]='X';
                            else board[i][j]='O';
                            moved=true;
                            break;
                        }
                }
                display();
            }
        }
    }
    public static boolean update(String s, char player)
    {
        //int i=Character.getNumericValue(s.charAt(1))-1;
        if (Character.isAlphabetic(s.charAt(1)))
        {
            System.out.println("Invalid move!");
            return false;
        }
        int i=Integer.parseInt(s.substring(1))-1;
        int j;
        for (j=0; j<size; j++)
            if (s.charAt(0)==a[j])
                break;
        if (i>=0 && i<size && j>=0 && j<size)
            if (board[i][j]=='.')
            {
                board[i][j]=player;
                return true;
            }
        System.out.println("Cannot place!");
        return false;
   }
    public static void display()
    {
        int x=1;
        System.out.print("    ");
        for (int i=0; i<size; i++)
            System.out.printf("%c  ",a[i]);
        System.out.printf("\n");

        for (int i=0; i<size; i++)
        {
            System.out.printf("%2d  ",x++);
            for (int j=0; j<size; j++)
                System.out.print(board[i][j]+"  ");
            System.out.printf("\n");
        }
    }
}
