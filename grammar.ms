import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class Prob1 {
    public static void main(String[] args) {
        String fileName = "test/hahahoho.txt";

        ArrayList<String> data = new ArrayList<String>();
        data.add("haha");
        data.add("hoho");
        writeFile(fileName, data);
        ArrayList<String> tmp = readFile(fileName);
        utilShowListValue(tmp);

        ArrayList<byte[]> bdata;
        writeBinFile(fileName + ".bins", data);
        bdata = readBinFile(fileName + ".bins");
        utilShowListValue(bdata);

        runCommand("cmd /c ls");

        dirList("./testdir");

        //inputConsole();

    }

    static public void utilShowListValue(ArrayList<?> data) {
        int cntData = data.size();
        for (int i = 0; i < cntData; i++) {
            System.out.println(data.get(i));
        }
    }

    static public void writeFile(String fileName, ArrayList<String> data)
    {
        String rootPath = System.getProperty("user.dir");
        String targetPath = rootPath + "/" + fileName;

        File file = new File(targetPath);
        file.getParentFile().mkdirs();

        FileWriter fw = null;
        try {
            fw = new FileWriter(targetPath);
        } catch (IOException e) {
            e.printStackTrace();
        }

        int cntData = data.size();
        for(int i = 0; i < cntData; i++) {
            try {
                fw.write(data.get(i) + "\r\n");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        try {
            fw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static public ArrayList<String> readFile(String fileName)
    {
        ArrayList<String> data = new ArrayList<String>();

        String rootPath = System.getProperty("user.dir");
        String targetPath = rootPath + "/" + fileName;

        BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader(targetPath));
        } catch (FileNotFoundException e1) {
            e1.printStackTrace();
        }

        while(true) {
            String line = null;
            try {
                line = br.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (line == null) break;
            data.add(line);
        }

        try {
            br.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return data;
    }

    static public void writeBinFile(String fileName, ArrayList<String> data)
    {
        String rootPath = System.getProperty("user.dir");
        String targetPath = rootPath + "/" + fileName;

        File file = new File(targetPath);
        file.getParentFile().mkdirs();

        FileOutputStream output = null;

        try {
            output = new FileOutputStream(fileName);
        } catch (FileNotFoundException e1) {
            e1.printStackTrace();
        }

        int cntData = data.size();
        for(int i = 0; i < cntData; i++) {
            try {
                output.write(data.get(i).getBytes());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        try {
            output.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static public ArrayList<byte[]> readBinFile(String fileName)
    {
        ArrayList<byte[]> data = new ArrayList<byte[]>();

        String rootPath = System.getProperty("user.dir");
        String targetPath = rootPath + "/" + fileName;

        byte[] bs = new byte[1024];
        FileInputStream input = null;

        try {
            input = new FileInputStream(targetPath);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        while (true) {
            try {
                if (input.read(bs) == -1) {
                    break;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            data.add(bs);
        }

        try {
            input.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return data;
    }

    static public void runCommand(String command) {
        String cmd = command;
        Process process;
        BufferedReader reader;
        String line;
        String result = "";

        try {
            process = Runtime.getRuntime().exec(cmd);
            reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            while((line=reader.readLine())!=null)
            {
                result += line + "\n";
            }

            System.out.println(result);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static public void dirList(String source){
        File dir = new File(source);
        File[] fileList = dir.listFiles();
        try{
            for(int i = 0 ; i < fileList.length ; i++){
                File file = fileList[i];
                if(file.isFile()){
                    System.out.println("file = " + file.getName());
                }else if(file.isDirectory()){
                    System.out.println("dir = " + file.getName());
                    dirList(file.getCanonicalPath().toString());
                }
            }
        }catch(IOException e){

        }
    }

    static public void socketClient(String ipAddress, int portNumber) {
        Socket clientSocket = null;
        OutputStream out = null;
        InputStream in = null;
        try {
            clientSocket = new Socket(ipAddress, portNumber);
            out = clientSocket.getOutputStream();
            in = clientSocket.getInputStream();

            String sendingMsg = "i'm client";
            out.write(sendingMsg.getBytes());

            byte [] receivedData = new byte[1024];
            int receivedDataByes = 0;
            while (true) {
                receivedDataByes = in.read(receivedData);
                if (receivedDataByes == -1)
                    break;
                System.out.println("received data: " + new String(receivedData, 0, receivedDataByes));
            }

            clientSocket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static public void socketServer(int portNumber) {
        ServerSocket serverSock;
        Socket clientSock;
        OutputStream out;
        InputStream in;

        try {
            serverSock = new ServerSocket(portNumber);
            clientSock = serverSock.accept();
            out = clientSock.getOutputStream();
            in = clientSock.getInputStream();

            String sendingMsg = "i'm server";
            out.write(sendingMsg.getBytes());

            byte [] receivedData = new byte[1024];
            int receivedDataByes = 0;
            while (true) {
                receivedDataByes = in.read(receivedData);
                if (receivedDataByes == -1)
                    break;
                System.out.println("received data: " + new String(receivedData, 0, receivedDataByes));
            }

            serverSock.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static public void inputConsole() {
        Scanner sc = new Scanner(System.in);

        String line;

        while(true)
        {
            line = sc.nextLine();
            String [] strArr = line.split("#|,");
            for(String str : strArr)
                System.out.print(str+" ");
            if (strArr[0].equals("quit"))
                break;
        }
    }

    static public boolean isDoubleString(String s) {
        try {
            Double.parseDouble(s);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    static public boolean isABC(String str)
    {
        return str.matches("^[A-Za-z]*$");
    }

    static public void getContents(HashMap<String, Integer> sourceList, HashMap<String, Integer> targetList) {
        File sourceFile = new File("source");
        File targetFile = new File("target");

        File [] sourceFiles = sourceFile.listFiles();
        for(File file: sourceFiles)
        {
            if(file.getName().equals("list.txt"))
                continue;

            BufferedReader br = null;

            try {
                br = new BufferedReader(new FileReader(file.getAbsolutePath()));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }

            String str = null;

            try {
                str = br.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }

            sourceList.put(file.getName(), Integer.parseInt(str));
        }

        File [] targetFiles = targetFile.listFiles();
        for(File file: targetFiles)
        {
            if(file.getName().equals("list.txt"))
                continue;

            BufferedReader br = null;

            try {
                br = new BufferedReader(new FileReader(file.getAbsolutePath()));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }

            String str = null;

            try {
                str = br.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }

            targetList.put(file.getName(), Integer.parseInt(str));
        }
    }

    public void writeContents(PrintWriter sourceWriter, PrintWriter targetWriter, HashMap<String, Integer> sourceList, HashMap<String, Integer> targetList)
    {
        try {
            sourceWriter = new PrintWriter(new FileWriter("source/list.txt"),true);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            targetWriter = new PrintWriter(new FileWriter("target/list.txt"),true);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        Set<String> keys = sourceList.keySet();
        for(String key: keys)
        {
            sourceWriter.println(key + "_" + sourceList.get(key));
        }

        keys = targetList.keySet();
        for(String key: keys)
        {
            targetWriter.println(key + "_" + targetList.get(key));
        }

        sourceWriter.close();
        targetWriter.close();
    }

    public void compareContents(HashMap<String, Integer> sourceList, HashMap<String, Integer> targetList)
    {
        Set<String> keys = sourceList.keySet();
        PrintWriter r_writer = null;
        String cmd = null;

        try {
            r_writer = new PrintWriter(new FileWriter("result.txt"),true);
        } catch (IOException e) {
            e.printStackTrace();
        }

        for(String key: keys)
        {
            if(targetList.containsKey(key))
            {
                if(sourceList.get(key) > targetList.get(key))
                { // copy
                    try {
                        cmd = "cmd /c cp source/" + key + " target/";
                        Runtime.getRuntime().exec(cmd);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    r_writer.println(key + "_C");

                }
                else // update
                {
                    r_writer.println(key + "_U");
                }
            }
            else // copy
            {
                try {
                    cmd = "cmd /c cp source/" + key + " target/";
                    Runtime.getRuntime().exec(cmd);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                r_writer.println(key + "_C");
            }

        }

        keys =targetList.keySet();
        for(String key: keys)
        {
            if(!sourceList.containsKey(key))
            {
                // delete
                try {
                    cmd = "cmd /c rm target/" + key;
                    Runtime.getRuntime().exec(cmd);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                r_writer.println(key + "_D");
            }
        }
        r_writer.close();
    }

    static public String getCurrentDateTime()
    {
        Date dt = new Date(System.currentTimeMillis());
        SimpleDateFormat fm = new SimpleDateFormat("yyyyMMddHHmmss");
        String timestring = fm.format(dt);
        return timestring;
    }

    static public String getCurrentDate()
    {
        Date dt = new Date(System.currentTimeMillis());
        SimpleDateFormat fm = new SimpleDateFormat("yyyyMMdd");
        String timestring = fm.format(dt);
        return timestring;
    }

    static public long hourDiff(String strTime1, String strTime2) throws ParseException
    {
        SimpleDateFormat fm = new SimpleDateFormat("yyyyMMddHHmmss");
        Date date1 = fm.parse(strTime1);
        Date date2 = fm.parse(strTime2);

        long gap = date1.getTime() - date2.getTime();

        return gap/60/60/1000;
    }

    static public void testRunnableThread() throws InterruptedException {
        Runnable r = new RunnableThread();
        ArrayList<Thread> runningThread = new ArrayList<Thread>();

        for(int i = 0 ; i < 10 ; i++ ){
            Thread test = new Thread(r);
            test.start();
            runningThread.add(test);
        }

        for(Thread t : runningThread){
            t.join();
        }
    }
}

class RunnableThread implements Runnable {
    static private int index = 0;

    synchronized void incIndex(){
        index++;
    }

    @Override
    public void run() {
        Random r = new Random(System.currentTimeMillis());
        try {
            long s = r.nextInt(10000);
            Thread.sleep(s);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        incIndex();
    }
}

class ExtendsThread extends Thread {
    static private int index = 0;

    private int threadId = -1;
    ExtendsThread(int threadId) {
        this.threadId = threadId;
    }

    synchronized public void incIndex(){
        index++;
    }

    @Override
    public void run() {
        Random r = new Random(System.currentTimeMillis());
        try {
            long s = r.nextInt(10000);
            Thread.sleep(s);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        incIndex();
    }

    public void test() {
        ArrayList<Thread> runningThread = new ArrayList<Thread>();

        for(int i = 0 ; i < 10 ; i++ ) {
            ExtendsThread test = new ExtendsThread(i);

            test.start();
            runningThread.add(test);
        }

        for(int i = 0 ; i < runningThread.size(); i++){
            try {
                runningThread.get(i).join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

    }
}

