package org.example;

import jssc.SerialPort;
import jssc.SerialPortException;
import jssc.SerialPortList;
import jssc.SerialPortEvent;

import javax.swing.*;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;


public class App 
{
    JLabel input = new JLabel("INPUT");
    JLabel output = new JLabel("OUTPUT");
    JLabel port = new JLabel("Port");

    JButton sendData = new JButton("Send Data");
    JButton connectButton = new JButton("Connect");
    JButton closeButton = new JButton("Close");
    JButton receiveButton = new JButton("Press to receive data");
    JTextArea inputText = new JTextArea(20, 30);
    JTextArea outputText = new JTextArea(20, 30);

    public JComboBox<String> ports = new JComboBox<>();

    JPanel SerialPort = new JPanel();
    private JFrame frame;
    JPanel panel;

    static SerialPort serialPort;

    public static void main( String[] args )
    {
        EventQueue.invokeLater(new Runnable() {
            @Override
            public void run() {
                try {
                    App window = new App();
                    window.frame.setVisible(true);
                }catch (Exception exception){
                    exception.printStackTrace();
                }
            }
        });
    }

    public App(){
        initialize();
    }

    public void initialize(){
        frame = new JFrame("Serial Port");
        frame.setSize(800,500);
        panel = new JPanel() {
            public Dimension getPreferredSize() {
                return new Dimension(800, 610);
            }
        };

        panel.setLayout(null);
        input.setBounds(100, 30, 100, 20);
        input.setFont(new Font("Serif", Font.BOLD, 20));
        input.setForeground(new Color(49,49,98));

        output.setBounds(550, 30, 100, 20);
        output.setFont(new Font("Serif", Font.BOLD, 20));
        output.setForeground(new Color(49,49,98));

        port.setBounds(50, 90, 100, 20);
        port.setFont(new Font("Serif", Font.BOLD, 18));

        ports.setBounds(100, 90, 100, 30);
        String[] portNames = SerialPortList.getPortNames();
        for (String name : portNames) {
            ports.addItem(name);
        }

        inputText.setBounds(50, 150, 250, 60);
        inputText.setBorder(BorderFactory.createLineBorder(new Color(49,49,98)));

        connectButton.setBounds(320, 350, 100, 35);
        connectButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                serialPort = new SerialPort((String) ports.getSelectedItem());
                try{
                    serialPort.openPort();
                    serialPort.setParams(115200,8,1,0);
                    System.out.println("Port is open");
                    JOptionPane.showMessageDialog(null,"The port is open","Mesaj",JOptionPane.INFORMATION_MESSAGE);
                } catch (SerialPortException serialPortException) {
                    System.out.println("Port is busy");
                    JOptionPane.showMessageDialog(null,"This port is busy","Error",JOptionPane.ERROR_MESSAGE);
                }
            }
        });

        sendData.setBounds(100, 230, 100, 35);
        sendData.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    serialPort.setParams(115200,8,1,0);
                    serialPort.writeBytes(inputText.getText().getBytes());//Write data to port
                }
                catch (SerialPortException ex) {
                    System.out.println(ex);
                }

            }
        });

        outputText.setBounds(450, 90, 300, 200);
        outputText.setEditable(false);
        outputText.setBorder(BorderFactory.createLineBorder(new Color(49,49,98)));

        receiveButton.setBounds(490, 310, 200, 35);
        receiveButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                outputText.append(writting());
            }
        });

        closeButton.setBounds(320, 390, 100, 35);
        closeButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                serialPort.closePort();
                ports.remove((ports.getSelectedIndex()));
                System.out.println("Port is close");
                JOptionPane.showMessageDialog(null,"The port is close","Mesaj",JOptionPane.INFORMATION_MESSAGE);
                } catch (SerialPortException ex) {
                    ex.printStackTrace();
                }
            }
        });

        panel.add(input);
        panel.add(output);
        panel.add(port);
        panel.add(ports);
        panel.add(sendData);
        panel.add(connectButton);
        panel.add(closeButton);
        panel.add(receiveButton);
        panel.add(inputText);
        panel.add(outputText);

        panel.setBackground(new Color(244, 241, 245));
        SerialPort.setMaximumSize(new Dimension(900, 610));
        SerialPort.add(panel);
        frame.setContentPane(SerialPort);
        frame.setVisible(true);
    }
    public String writting()
    {
        String sir = "";
        char result = 0;
        try {
            serialPort.setParams(115200, 8, 1, 0);//Set params.
            byte[] buffer = serialPort.readBytes(1);//Read 10 bytes from serial port
            result = (char) buffer[0];
            int mask = SerialPortEvent.RXCHAR + SerialPortEvent.CTS + SerialPortEvent.DSR;
            serialPort.setEventsMask(mask); // Set mask
        }
        catch (SerialPortException ex) {
            System.out.println(ex);
        }
        sir = String.valueOf(result);
        return sir;
    }
}
