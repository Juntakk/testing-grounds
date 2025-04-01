import {
  Home,
  Shapes,
  Trophy,
  Zap,
  BarChart3,
  Users,
  Calendar,
  Settings,
} from "lucide-react";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import BarChartOne from "./BarChartOne";

export default function BlockLayout() {
  return (
    <div className="container px-48 p-8 shadow-md rounded-lg">
      <h2 className="text-3xl font-bold tracking-tight mb-6 text-center">
        Dashboard Overview
      </h2>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column */}
        <div className="lg:col-span-3 space-y-6">
          <Card className="h-[300px] bg-gray-700">
            <CardHeader>
              <CardTitle>Activity</CardTitle>
              <CardDescription>Your recent activity</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="flex items-center gap-3">
                  <div className="h-2 w-full bg-gray-600 rounded-full overflow-hidden">
                    <div className="h-full bg-primary w-[75%]" />
                  </div>
                  <span className="text-sm font-medium">75%</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="h-2 w-full bg-gray-600 rounded-full overflow-hidden">
                    <div className="h-full bg-primary w-[45%]" />
                  </div>
                  <span className="text-sm font-medium">45%</span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="h-2 w-full bg-gray-600 rounded-full overflow-hidden">
                    <div className="h-full bg-primary w-[90%]" />
                  </div>
                  <span className="text-sm font-medium">90%</span>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gray-700">
            <CardHeader>
              <CardTitle>Quick Actions</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 gap-2">
                <button className="flex flex-col items-center justify-center p-4 rounded-lg bg-gray-600 hover:bg-gray-500 transition-colors">
                  <Home className="h-6 w-6 mb-2 text-white" />
                  <span className="text-xs font-medium">Home</span>
                </button>
                <button className="flex flex-col items-center justify-center p-4 rounded-lg bg-gray-600 hover:bg-gray-500 transition-colors">
                  <Settings className="h-6 w-6 mb-2 text-white" />
                  <span className="text-xs font-medium">Settings</span>
                </button>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Center Column */}
        <div className="lg:col-span-6">
          <Card className="h-full bg-gray-700">
            <CardHeader>
              <CardTitle>Performance Overview</CardTitle>
              <CardDescription>Monthly statistics</CardDescription>
            </CardHeader>
            <CardContent>
              <BarChartOne />
            </CardContent>
          </Card>
        </div>

        {/* Right Column */}
        <div className="lg:col-span-3 space-y-6">
          <Card className="bg-gray-700">
            <CardHeader>
              <CardTitle>Summary</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center">
                    <Users className="h-4 w-4 mr-2 text-gray-400" />
                    <span className="text-sm">Total Users</span>
                  </div>
                  <span className="font-medium">1,248</span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center">
                    <BarChart3 className="h-4 w-4 mr-2 text-gray-400" />
                    <span className="text-sm">Revenue</span>
                  </div>
                  <span className="font-medium">$24,780</span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center">
                    <Calendar className="h-4 w-4 mr-2 text-gray-400" />
                    <span className="text-sm">Projects</span>
                  </div>
                  <span className="font-medium">32</span>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gray-700">
            <CardHeader>
              <CardTitle>Quick Stats</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 gap-2">
                {[
                  { icon: Trophy, label: "Awards", value: "12" },
                  { icon: Shapes, label: "Projects", value: "36" },
                  { icon: Zap, label: "Energy", value: "85%" },
                  { icon: Home, label: "Visits", value: "2.4k" },
                ].map((item, index) => (
                  <div
                    key={index}
                    className="bg-gray-600 rounded-lg p-3 flex flex-col items-center justify-center"
                  >
                    <item.icon className="h-5 w-5 mb-1 text-primary" />
                    <span className="text-xs text-gray-400">{item.label}</span>
                    <span className="font-medium text-sm">{item.value}</span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
