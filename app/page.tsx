import { DataTableDemo } from "@/components/DataTable";
import Layout1 from "@/components/Layout1";
import PaginationComponent from "@/components/PaginationComponent";
import TimerComponent from "@/components/Timer";

export default function Home() {
  return (
    <div>
      <TimerComponent />
      <DataTableDemo />
      <Layout1 />
      <PaginationComponent />
    </div>
  );
}
